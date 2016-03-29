#stats.files <- commandArgs(TRUE)

stats.files <- c("results/alignment-stats-orig-clusters.tsv", "results/2015-11-23-clusters-1/alignment-stats.tsv")

data <- lapply(stats.files, read.table, header=T)

names(data) <- c('data', paste0('sim')) #-', 1:(length(data)-1)))

## scale ietms with percentage values
for (i in seq(1, length(data))) {
    # turn gap frequency in percentage
    data[[i]][,'gap_freq'] <- data[[i]][,'gap_freq'] * 100
    data[[i]][,'prop_invar'] <- data[[i]][,'prop_invar'] * 100
}

## summarize deletions and insertions to indels

for (i in 1:length(data) ) {
    data[[i]][['indel_count']] <- data[[i]]$ins_count + data[[i]]$del_count
    data[[i]][['indel_avg_size']] <- (data[[i]]$del_avg_size + data[[i]]$ins_avg_size) / 2
}


## define properties to plot
# vars <- colnames(data[[1]])[- ( which(colnames(data[[1]]) %in% c('file', 'species')))]
vars <- c('avg_dist',  'prop_invar', 'indel_count', 'indel_avg_size',  'gaps_per_seq', 'gap_freq')

pdf('alnstats.pdf', width=5, height=10)
par(mfrow=c(4,2))

# make name mapping for plot titles and axis labels
mapping <- data.frame(row.names=colnames(data[[1]]))
mapping$title <- 0;
mapping$ylab <- 0;
mapping['del_avg_size', 'title'] <- 'Average size of deletions\nper alignment'
mapping['del_avg_size', 'ylab'] <- 'size (nucleotides)'
mapping['del_count', 'title'] <- 'Number of deletions\nper alignment'
mapping['del_count', 'ylab'] <- 'count'

mapping['indel_avg_size', 'title'] <- 'Average size of indels\nper alignment'
mapping['indel_avg_size', 'ylab'] <- 'size (nucleotides)'
mapping['indel_count', 'title'] <- 'Number of indels\nper alignment'
mapping['indel_count', 'ylab'] <- 'count'

mapping['gap_freq', 'title'] <- '% gaps per sequence'
mapping['gap_freq', 'ylab'] <- '%'
mapping['gaps_per_seq', 'title'] <- 'Number of gaps\nper sequence'
mapping['gaps_per_seq', 'ylab'] <- 'gap count'

mapping['ins_avg_size', 'title'] <- 'Average size of insertions\nper alignment'
mapping['ins_avg_size', 'ylab'] <- 'size (nucleotides)'
mapping['ins_count', 'title'] <- 'Number of insertions\nper alignment'
mapping['ins_count', 'ylab'] <- 'count'

mapping['nchar', 'title'] <- 'Number of nucleotides\nper sequence'
mapping['nchar', 'ylab'] <- 'nucleotides'
mapping['ntax', 'title'] <- 'Number of taxa in alignment'
mapping['ntax', 'ylab'] <- 'taxa'

mapping['prop_invar', 'title'] <- '% of invariant sites\nper alignment'
mapping['prop_invar', 'ylab'] <- '%'

mapping['ident_pairs', 'title'] <- 'Identical sequences in alignment'
mapping['ident_pairs', 'ylab'] <- 'number of identical pairs'

mapping['avg_dist', 'title'] <- 'average distance\nwithin alignment'
mapping['avg_dist', 'ylab'] <- 'relative edit distance'



## make boxplots for all valiables
for ( v in vars ) {
    a <- boxplot( lapply(data, '[[', v), main=mapping[v, 'title'], ylab=mapping[v, 'ylab'], names=names(data), outline=F, col=c('grey', rep('white', length(data)-1)), cex.main=1.5, cex.axis=1.2, cex.lab=1.5)

    ## code for plotting histograms
    ##    colors <- sapply(palette(), scales::alpha, .5)
    ##    for (i in seq(1, length(data))) {
    ##        hist( data[[i]][,v], prob=T, add=!i==1, col=colors[i], breaks=20)
    ##    }
    ##    colors <- palette()
    ##    for (i in seq(1, length(data))) {
    ##        lines( density(data[[i]][,v], adjust=2), col=colors[i] )
    ##    }
}

## calculate and plot number of alignments per species and story in list
spec.stats <- list()
for (i in seq(1, length(data))) {
    specs <- as.numeric(unlist(sapply(as.character(data[[i]]$species), strsplit, split=',')))
    unique.specs <- unique(specs)
    df <- data.frame('species'=unique.specs, 'counts'=sapply(unique.specs, function(x)sum(specs==x)))
    spec.stats[[i]] <- df
}
#boxplot(lapply(spec.stats, '[[', 'counts'), main="Number of alignments per species", ylab="alignments", names=names(data), cex.axis=1.2, cex.main=1.5, cex.lab=1.5)


dev.off()
