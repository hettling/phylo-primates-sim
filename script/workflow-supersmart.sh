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
export SUPERSMART_CLADE_MAX_COVERAGE="5"

FOSSILS="fossils.tsv"
#BACKBONE="backbone-exabayes.dnd"
BACKBONE="backbone-exabayes.dnd"
SUPERMATRIX="supermatrix.phy"



#if [ ! -e "$WORKDIR/merged.txt" ]; then
#    smrt orthologize -i $WORKDIR/aligned-smrt-inserted.txt -w $WORKDIR -l orthologize.log
#fi

#if [ ! -e "$WORKDIR/supermatrix.phy" ]; then
#    smrt bbmerge -t $WORKDIR/taxa-replicated.tsv -a merged.txt -o $SUPERMATRIX -w $WORKDIR -l bbmerge.log
#fi

if [ ! -e "$WORKDIR/markers-backbone.dot" ]; then
    smrt-utils markergraph -i $WORKDIR/markers-backbone.tsv -o markers-backbone.dot -w $WORKDIR
fi
export SUPERSMART_NODES="16"

#export SUPERSMART_NUMCHAINS="2"
#if [ ! -e "$WORKDIR/$BACKBONE" ]; then
#smrt bbinfer -i examl -b 100 -s $WORKDIR/supermatrix.phy -o $BACKBONE -w $WORKDIR -l bbinfer.log -m
smrt bbinfer -i exabayes -s $WORKDIR/supermatrix.phy -o $BACKBONE -w $WORKDIR -l bbinfer-exabayes.log
#fi

#if [ ! -e "$WORKDIR/backbone-rerooted.dnd" ]; then
smrt bbreroot -b $BACKBONE -t $WORKDIR/taxa-replicated.tsv -p $WORKDIR/tree-replicated.dnd -w $WORKDIR
#fi

#if [ ! -e "$WORKDIR/chronogram.dnd" ]; then
smrt bbcalibrate -t $WORKDIR/backbone-rerooted.dnd -f $FOSSILS -w $WORKDIR
#fi

#if [ ! -e "$WORKDIR/consensus.nex" ]; then
smrt consense -i $WORKDIR/chronogram.dnd -w $WORKDIR -o consense-exabayes.dnd
#fi
exit 0;

#smrt bbdecompose -b $WORKDIR/consense-examl.nex -a $WORKDIR/aligned-smrt-inserted.txt -t $WORKDIR/taxa-replicated.tsv -w $WORKDIR
smrt clademerge --enrich -w $WORKDIR
smrt cladeinfer --ngens=15_000_000 --sfreq=1000 --lfreq=1000 -w $WORKDIR
smrt cladegraft -w $WORKDIR -o tree-reestimated.nex -b consense-examl.nex

# clean database from artificial sequences
#sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from seqs where acc like "$WORKDIR%"'
#sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from nodes_194 where common_name like "$WORKDIR%"'
