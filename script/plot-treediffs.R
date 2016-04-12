require('ape')
source('mycophyloplot.R')

rep <- read.tree('../results/2016-02-04-clusters/tree-replicated.dnd')
final <- read.tree('../results/2016-02-04-clusters/tree-reestimated-pruned-sorted.dnd')

# association matrix
association <- cbind(final$tip.label, final$tip.label)

# determine colors for associations, need mapping between species and clades.
# This can be done as follows: for i in $(ls -d clade*); do while read -r line; do echo $i $line; done < $i/species.tsv; done | grep -v superkingdom | cut -d " " -f 1,2
tab <- read.table('../results/2016-02-04-clusters/clade-species.tsv')
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

# need exemplars file: cat markers-backbone.tsv  | cut -f 1 | grep -v superkingdom
exemplars = scan('../results/2016-02-04-clusters/exemplars.tsv', what='character')



#rem <- rep$tip.label[which(sapply(sapply(rep$tip.label, strsplit, "_"), `[[`, 1)!="Ateles")]

#rep <- drop.tip(rep, rem)
#final <- drop.tip(final, rem)
#exemplars <- exemplars[which(! exemplars %in% rem)]

## for figure 5b in main text
pdf("trees-sidebyside-fig5b.pdf", 20, 20)
mycophyloplot(rep, final, space=20, gap=-26, assoc=association, length.line=0.0, lwd=3, col=colors, exemplars=exemplars, show.tip.label=F, use.edge.length=T)
#mycophyloplot(rep, final, space=100, gap=5, assoc=NULL, length.line=10, lwd=1, col=colors, exemplars=exemplars, show.tip.label=T, use.edge.length=T)
dev.off()

pdf("trees-sidebyside-fig")


