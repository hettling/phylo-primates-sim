require('ape')
source('mycopyloplot.R')

rep <- read.tree('tree-replicated-sorted-labels.dnd')
final <- read.tree('final-sorted-labels.dnd')

# association matrix
association <- cbind(final$tip.label, final$tip.label)

# determine colors for associations
tab <- read.table('clade-species.tsv')
clades <- levels(tab[,1])
clade_cols <- data.frame(clade=clades, color=rainbow(length(clades))[sample(seq_along(clades))]) #shuffle

colors <- unlist(sapply(association[,1], function(s) {
    clade=as.character(tab[which(tab[,2]==s),1])
    color = as.character(clade_cols[which(clade_cols$clade==clade),2])
    if (length(color) > 0)
        return (color)
    else
        return ('black')
}))

exemplars = scan('exemplars.tsv', what='character')

pdf("nolab3.pdf", 20, 20)
mycophyloplot(rep, final, space=100, gap=5, assoc=association, length.line=10, lwd=1, col=colors, type="cladogram", exemplars=exemplars, show.tip.label=F)
dev.off()

