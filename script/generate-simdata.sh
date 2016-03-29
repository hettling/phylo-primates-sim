#!/bin/bash

# This script uses simulations to replicate a dataset from a pervious
# SUPERSMART run. Replication includes making a synthetic tree 
# resembling the final tree from the analysis, an appropriate taxa
# file and simulated sequence alignment files.
 
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

# define directories
WORKDIR="$PWD/results/$SIMNAME" 

# make directory to store all files for simulation analysis
if [ ! -d $WORKDIR ]; then
	mkdir $WORKDIR
fi

INTREE="$PWD/data/tree/final.nex"
FOSSILS="$PWD/data/fossils/fossils.tsv"

# take tree that was already replicated
REPTREE="$PWD/data/tree/tree-replicated.dnd"

# make file listing original alignments
ALNS=$WORKDIR/aligned.txt
for i in $( ls data/alignments/*subtree.fa ); do echo $PWD/$i; done > $ALNS

# copy files from previous SUPERSMART run necessary to replicate tree and data
cp $INTREE $WORKDIR
cp $REPTREE $WORKDIR
cp $FOSSILS $WORKDIR
cd $WORKDIR

echo "$WORKDIR/replicate.log"

# Replicate the dataset (final tree, taxa table and alignments)
smrt-utils replicate -t $INTREE -f nexus -a $ALNS -l "$WORKDIR/replicate.log" -v -d -r "$WORKDIR/tree-replicated.dnd"

# Make summary table of simulation data: 
smrt-utils alnstats -a $WORKDIR/aligned-replicated.txt

# insert simulated sequences and possible artificial taxa into the database
# prefix for sequence accessions is the simulation directory
smrt-utils dbinsert -s aligned-replicated.txt -t taxa-replicated.tsv -p $SIMNAME -v -w $WORKDIR
