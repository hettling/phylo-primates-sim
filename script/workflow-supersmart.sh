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
export SUPERSMART_BACKBONE_MAX_DISTANCE="0.1"
export SUPERSMART_BACKBONE_MIN_COVERAGE="3"
export SUPERSMART_BACKBONE_MAX_COVERAGE="5"
export SUPERSMART_CLADE_MAX_DISTANCE="0.2"
export SUPERSMART_CLADE_MIN_DENSITY="0.5"
export SUPERSMART_CLADE_MIN_COVERAGE="2"
export SUPERSMART_CLADE_MAX_COVERAGE="10"

FOSSILS='fossils.tsv'
BACKBONE='backbone-examl.dnd'

smrt orthologize -i aligned-smrt-inserted.txt -w $WORKDIR
smrt bbmerge -t taxa-replicated.tsv -a merged.txt -w $WORKDIR
smrt bbinfer -i examl -b 100 -s supermatrix.phy -o $BACKBONE -w $WORKDIR
smrt bbreroot -b $BACKBONE -t taxa-replicated.tsv -w $WORKDIR
smrt bbcalibrate -t backbone-rerooted.dnd -f $FOSSILS -w $WORKDIR
smrt consense -i chronogram.dnd -w $WORKDIR

smrt bbdecompose -b consensus.nex -a aligned-smrt-inserted.txt -t taxa-replicated.tsv -w $WORKDIR
smrt clademerge --enrich -w $WORKDIR
smrt cladeinfer --ngens=30_000_000 --sfreq=1000 --lfreq=1000 -w $WORKDIR
smrt cladegraft -w $WORKDIR

# clean database from artificial sequences
#sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from seqs where acc like "$WORKDIR%"'
#sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from nodes_194 where common_name like "$WORKDIR%"'
