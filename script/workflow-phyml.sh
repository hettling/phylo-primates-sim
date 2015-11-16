#!/bin/bash

# This script runs phyml  on a mega-matrix generated from
# simulation data. This script should be called from the top-level directory  

# parse command-line arguments for simulation directory 
SIMNAME=$1

# define files and directories
WORKDIR="$PWD/results/$SIMNAME" 

MEGAMATRIX="$WORKDIR/megamatrix.phy"

cd $WORKDIR

phyml -i $MEGAMATRIX
