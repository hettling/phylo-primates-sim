
# get stats of original alignment
ORIG_ALNS='results/aligned-orig.txt'
ORIG_STATS='results/alignment-stats-orig.tsv'
#for i in $( ls data/alignments/*.fa ); do echo $PWD/$i; done > $ORIG_ALNS

#smrt-utils alnstats -a $ORIG_ALNS -o $ORIG_STATS

STATSFILES=$(ls results/2015-11-10-sim-*/alignment-stats.tsv)

echo $ORIG_STATS $STATSFILES

Rscript script/plot-aln-stats.R  $ORIG_STATS $STATSFILES