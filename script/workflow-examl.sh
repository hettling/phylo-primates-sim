#!/bin/bash

# This script runs raxml  on a mega-matrix generated from
# simulation data. This script should be called from the top-level directory  

# parse command-line arguments for simulation directory 
SIMNAME=$1

# define files and directories
WORKDIR="$PWD/results/$SIMNAME" 

MEGAMATRIX="$WORKDIR/megamatrix.phy"

cd $WORKDIR

export SUPERSMART_NODES="64"
smrt bbinfer -i examl -b 1 -m -s $MEGAMATRIX -o megatree-examl.dnd -w $WORKDIR -l infer-raxml.log -t $WORKDIR/taxa-replicated.tsv

