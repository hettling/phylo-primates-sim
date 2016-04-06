#!/bin/bash

# This script runs garli on a mega-matrix generated from
# simulation data. This script should be called from the top-level directory  

# load garli
module load bioinfo-tools
module load garli

# parse command-line arguments for simulation directory 
SIMNAME=$1

export SUPERSMART_NODES=1

# define files and directories
WORKDIR="$PWD/results/$SIMNAME" 
CONF="$PWD/script/garli.conf"

# copy configuration file to working diorectory
cp $CONF  $WORKDIR

MEGAMATRIX="$WORKDIR/megamatrix.nex"

cd $WORKDIR

Garli -b $CONF
