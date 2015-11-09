#!/bin/bash

#SBATCH -A snic2015-1-72
#SBATCH -t 48:00:00
#SBATCH -p node -n 16
          
module load openmpi/1.6.5 
module load bioinfo-tools
module load blast/2.2.29+
export PATH=$PATH:/home/hannesh/SUPERSMART/tools/bin/
export PATH=$PATH:/home/hannesh/SUPERSMART/src/supersmart/script
export TMPDIR="/home/hannesh/glob/tmp/$1"
mkdir $TMPDIR

sh workflow-sim.sh $1

echo "DONE"
