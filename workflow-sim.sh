#!/bin/bash

# This script uses simulations to replicate a dataset from a pervious
# SUPERSMART run. Replication includes making a synthetic tree 
# resembling the final tree from the analysis, an appropriate taxa
# file and simulated sequence alignment files.
# Subsequently, the supersmart pipeline is ran again 
# on the synthetic dataset. The tree infered from this tree inference
# can then directly be compared to the 'original' replicated tree. Thereby,
# the performance of the SUPERSMART method can be validated. 
 
# Note that running this script will take considerable time and resources,
# so it is best to run it on a cluster computer.

# Note that this script needs the alignment files and final tree from
# a prevously completed supersmart run.

# A directory name to store all simulated data and analysis results can be provided
# as an argument, if not given it defaults to 'results/simulations/' 

# parse command-line arguments for simulation directory 
SIMNAME=$1
if [ -z "$SIMNAME" ]; then       
        SIMNAME='simulations'
fi

# define dirs and directories
WORKDIR="$PWD/results/$SIMNAME" 

# make directory to store all files for simulation analysis
if [ ! -d $WORKDIR ]; then
	mkdir $WORKDIR
fi

INTREE="$PWD/data/tree/final.nex"
FOSSILS="$PWD/data/fossils/fossils.tsv"

# make file listing original alignments
ALNS=$WORKDIR/aligned.txt
for i in $( ls data/alignments/*.fa ); do echo $PWD/$i; done > $ALNS

# copy files from previous SUPERSMART run necessary to replicate tree and data
cp $INTREE $WORKDIR
cp $FOSSILS $WORKDIR
cd $WORKDIR

echo "$WORKDIR/replicate.log"

# Replicate the dataset (final tree, taxa table and alignments)
smrt-utils replicate -t $INTREE -f nexus -a $ALNS -l "$WORKDIR/replicate.log" -v
# insert simulated sequences and possible artificial taxa into the database
# prefix for sequence accessions is the simulation directory
smrt-utils dbinsert -s aligned-replicated.txt -t taxa-replicated.tsv -p $SIMNAME -v -w $WORKDIR

# run the supersmart pipeline in the directory of the replicated dataset
export SUPERSMART_BACKBONE_MAX_DISTANCE="0.1"
export SUPERSMART_BACKBONE_MIN_COVERAGE="3"
export SUPERSMART_BACKBONE_MAX_COVERAGE="5"
export SUPERSMART_CLADE_MAX_DISTANCE="0.2"
export SUPERSMART_CLADE_MIN_DENSITY="0.5"
export SUPERSMART_CLADE_MIN_COVERAGE="2"
export SUPERSMART_CLADE_MAX_COVERAGE="10"

smrt orthologize -i aligned-smrt-inserted.txt -w $WORKDIR
smrt bbmerge -t taxa-replicated.tsv -a merged.txt -w $WORKDIR
smrt bbinfer -i exabayes -s supermatrix.phy -w $WORKDIR
smrt bbreroot -b backbone.dnd -t taxa-replicated.tsv -w $WORKDIR
smrt bbcalibrate -t backbone-rerooted.dnd -f $FOSSILS
smrt consense -i chronogram.dnd -w $WORKDIR

smrt bbdecompose -b consensus.nex -a aligned-smrt-inserted.txt -t taxa-replicated.tsv -w $WORKDIR
smrt clademerge --enrich -w $WORKDIR
smrt cladeinfer --ngens=30_000_000 --sfreq=1000 --lfreq=1000 -w $WORKDIR
smrt cladegraft -w $WORKDIR

# clean database from artificial sequences
sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from seqs where acc like "$WORKDIR%"'
sqlite3 $SUPERSMART_HOME/data/phylota.sqlite 'delete from nodes_194 where common_name like "$WORKDIR%"'
