#!/bin/bash

# This script runs the SUPERSMART pipeline
# on a synthetic dataset. The tree infered from this tree inference
# can then directly be compared to the 'original' replicated tree. Thereby,
# the performance of the SUPERSMART method can be validated.

# parse command-line arguments for simulation directory
SIMNAME=$1
if [ -z "$SIMNAME" ]; then
        SIMNAME='simulations'
fi

# define dirs and directories
WORKDIR="$PWD/results/$SIMNAME"

# run the supersmart pipeline in the directory of the replicated dataset
export SUPERSMART_BACKBONE_MAX_DISTANCE="0.2"
export SUPERSMART_BACKBONE_MIN_COVERAGE="3"
export SUPERSMART_BACKBONE_MAX_COVERAGE="3"
export SUPERSMART_CLADE_MAX_DISTANCE="0.2"
export SUPERSMART_CLADE_MIN_DENSITY="0.5"
export SUPERSMART_CLADE_MIN_COVERAGE="2"
export SUPERSMART_CLADE_MAX_COVERAGE="10"

FOSSILS='fossils.tsv'
BACKBONE='backbone-examl.dnd'
SUPERMATRIX='supermatrix.phy'

if [ ! -e "$WORKDIR/merged.txt" ]; then
    smrt orthologize -i aligned-smrt-inserted.txt -w $WORKDIR -l orthologize.log
fi

if [ ! -e "$WORKDIR/supermatrix.phy" ]; then
    smrt bbmerge -t taxa-replicated.tsv -a merged.txt -o $SUPERMATRIX -w $WORKDIR -l bbmerge.log
fi

if [ ! -e "$WORKDIR/markers-backbone.dot" ]; then
    smrt-utils markergraph -i markers-backbone.tsv -o markers-backbone.dot -w $WORKDIR
fi

if [ ! -e "$WORKDIR/$BACKBONE" ]; then
    smrt bbinfer -i examl -b 100 -s supermatrix.phy -m -o $BACKBONE -w $WORKDIR -l bbinfer.log
fi

if [ ! -e "$WORKDIR/backbone-rerooted.dnd" ]; then
    smrt bbreroot -b $BACKBONE -t taxa-replicated.tsv -p tree-replicated.dnd -w $WORKDIR
fi

if [ ! -e "$WORKDIR/chronogram.dnd" ]; then
    smrt bbcalibrate -t backbone-rerooted.dnd -f $FOSSILS -w $WORKDIR
fi

if [ ! -e "$WORKDIR/consensus.nex" ]; then
    smrt consense -i chronogram.dnd -w $WORKDIR
fi

smrt bbdecompose -b consensus.nex -a aligned-smrt-inserted.txt -t taxa-replicated.tsv -w $WORKDIR
smrt clademerge --enrich -w $WORKDIR
smrt cladeinfer --ngens=15_000_000 --sfreq=1000 --lfreq=1000 -w $WORKDIR
smrt cladegraft -w $WORKDIR -o 'tree-reestimated.nex'

# clean database from artificial sequences
#sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from seqs where acc like "$WORKDIR%"'
#sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from nodes_194 where common_name like "$WORKDIR%"'
