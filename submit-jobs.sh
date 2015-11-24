#!/bin/bash

PREFIX=2015-11-23-clusters-1

# mrbayes
#sbatch -n 16 -o $PREFIX-mrbayes.out  -J mrbayes-$PREFIX run-tintin.sh script/workflow-mrbayes.sh $PREFIX
# garli
#sbatch -n 1  -p -o $PREFIX-garli.out  -J garli-$PREFIX sh run-tintin.sh script/workflow-garli.sh $PREFIX
# raxml
#sbatch  -o $PREFIX-raxml.out  -J raxml-$PREFIX run-halvan.sh script/workflow-raxml.sh $PREFIX
# examl
sbatch  -o $PREFIX-examl.out  -J examl-$PREFIX run-halvan.sh script/workflow-examl.sh $PREFIX
# phyml
#sbatch  -o $PREFIX-phyml.out  -J phyml-$PREFIX run-halvan.sh script/workflow-phyml.sh $PREFIX




