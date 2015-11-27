use strict;
use warnings;
use Bio::Phylo::IO qw(parse);

my $t1 = "tree-replicated.dnd";
my $t2 = "final.nex";

my $tree1 = parse(
	'-file'   => $t1,
	'-format' => "newick",
	)->first;

my $tree2 = parse(
	'-file'   => $t2,
	'-format' => "figtree",
	)->first;

my @labels;
$tree1->visit_depth_first(	
	# pre-order
	'-pre' => sub {
		my $n = shift;
		if ( $n->is_terminal ) {
			my $name = $n->get_name;				
			push @labels, $name;
		}
	}
	);

$tree1->sort_tips(\@labels);
$tree2->sort_tips(\@labels);
$tree2->ultrametricize;

open my $fh, '>', "tree-replicated-sorted.dnd";
print $fh $tree1->to_newick;
close $fh;
open my $fh2, '>', "final-sorted.nex";
print $fh2 $tree2->to_nexus('-nodelabels'=>1);
close $fh2;
