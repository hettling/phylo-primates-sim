#!/bin/bash

#SBATCH -A snic2015-1-72
#SBATCH -t 24:00:00
#SBATCH -p node 

module load openmpi/1.6.5 
module load bioinfo-tools
module load blast/2.2.29+
export PATH=$PATH:/home/hannesh/SUPERSMART/tools/bin/
export PATH=$PATH:/home/hannesh/SUPERSMART/src/supersmart/script

SCRIPT=$1
ARG=$2

sh $SCRIPT $ARG

wait
echo "DONE executing $SCRIPT $ARG"
