#!/bin/bash

# This script runs mrbayes on a mega-matrix generated from
# simulation data. This script should be called from the top-level directory  

# load mrbayes
module unload openmpi/1.6.5
module load bioinfo-tools
module load mrbayes

# parse command-line arguments for simulation directory 
SIMNAME=$1

# define dirs
WORKDIR="$PWD/results/$SIMNAME" 

MEGAMATRIX="$WORKDIR/megamatrix.nex"

cd $WORKDIR
mpirun -np 16 mb $MEGAMATRIX

