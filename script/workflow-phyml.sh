#!/bin/bash

# This script runs phyml  on a mega-matrix generated from
# simulation data. This script should be called from the top-level directory  

# parse command-line arguments for simulation directory 
SIMNAME=$1

# define files and directories
WORKDIR="$PWD/results/$SIMNAME" 

MEGAMATRIX="$WORKDIR/megamatrix.phy"

export SUPERMSART_NODES=64

cd $WORKDIR

smrt bbinfer -i phyml -v -b 100 -s $MEGAMATRIX -o megatree-phyml.dnd -w $WORKDIR -l infer-phyml.log -t $WORKDIR/taxa-replicated.tsv

