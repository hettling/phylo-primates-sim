#!/bin/bash

# prefix for simulation dir passed as argument, otherwise set ti current date
PREFIX=$1
if [ -z $PREFIX ]; then       
    PREFIX=`date +%Y-%m-%d`;
fi

# cluster queue submission 
for i in {1..5}; do sbatch -o sun-primates-sim-smrt-$i.out -J new-primates-sim-smrt-$i run.sh $PREFIX-$i; done

# simple call
#for i in {1..10}; do sh run.sh $PREFIX-sim-$i; done
