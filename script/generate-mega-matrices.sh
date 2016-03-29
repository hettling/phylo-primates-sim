#!/bin/bash

# This script runs the first half of the SUPERSMART
# pipeline on a synthetic dataset to create mega-matrices in the following formats:
# phylip, mrbayes

# parse command-line arguments for simulation directory 
SIMNAME=$1
if [ -z "$SIMNAME" ]; then       
        SIMNAME='simulations'
fi

# define dirs and directories
WORKDIR="$PWD/results/$SIMNAME" 

# run the supersmart pipeline in the directory of the replicated dataset
export SUPERSMART_BACKBONE_MAX_DISTANCE="0.2"
export SUPERSMART_BACKBONE_MIN_COVERAGE="2"
export SUPERSMART_BACKBONE_MAX_COVERAGE="20"

MERGED="merged-mega.txt"

smrt orthologize -i aligned-smrt-inserted.txt -o $MERGED -w $WORKDIR

# phylip
smrt bbmerge -t taxa-replicated.tsv -a $MERGED -e -1  -m markers-mega.tsv -f phylip -o megamatrix.phy -w $WORKDIR

# mrbayes
smrt bbmerge -t taxa-replicated.tsv -a $MERGED -e -1  -m markers-mega.tsv -f mrbayes -o megamatrix.nex -w $WORKDIR

# fasta
smrt bbmerge -t taxa-replicated.tsv -a $MERGED -e -1  -m markers-mega.tsv -f fasta -o megamatrix.fa -w $WORKDIR
