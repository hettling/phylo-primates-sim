#!/bin/bash

# This script runs raxml  on a mega-matrix generated from
# simulation data. This script should be called from the top-level directory  

# parse command-line arguments for simulation directory 
SIMNAME=$1

export SUPERMSART_NODES=32

# define files and directories
WORKDIR="$PWD/results/$SIMNAME" 

MEGAMATRIX="$WORKDIR/megamatrix.phy"

cd $WORKDIR

smrt bbinfer -i examl -b 100 -m -v -s $MEGAMATRIX -o megatree-examl.dnd -w $WORKDIR -l infer-examl.log -t $WORKDIR/taxa-replicated.tsv 

