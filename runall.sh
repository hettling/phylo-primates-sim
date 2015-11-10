#!/bin/bash


# date of sim can be passed as argument, otherwise it is current date
SIMDATE=$1
if [ -z "$SIMDATE" ]; then       
    SIMDATE=`date +%Y-%m-%d`;
fi

# cluster queue submission 
for i in {1..10}; do sbatch -o primates-sim-tab-$i.out -J primates-sim-tab-$i run.sh -sim-$i; done

# simple call
#for i in {1..10}; do sh run.sh $SIMDATE-sim-$i; done
