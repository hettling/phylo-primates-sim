use strict;
use warnings;

use Bio::Phylo::SUPERSMART::Service::MarkersAndTaxaSelector;
use Bio::Phylo::IO 'parse_matrix';

my $mt =  Bio::Phylo::SUPERSMART::Service::MarkersAndTaxaSelector->new;

my $pattern = $ARGV[0];

my @clusters = glob($pattern);

my $total_identical = 0;
for my $file ( @clusters ) {

	my $matrix = parse_matrix(
		'-file'       => $file,
		'-format'     => 'fasta',
		'-type'       => 'dna',
		);

	my @rows = @{$matrix->get_entities};

	my $identical = 0;
	for (my $i=0; $i<=$#rows; $i++) {
		my $row_i = $rows[$i];
		for (my $j=$i+1; $j<=$#rows; $j++) {
			my $row_j = $rows[$j];

			#print "Comparing " . $row_i->get_name . " and " . $row_j->get_name . "\n";
			if ($row_i->get_char eq $row_j->get_char) {

				my $name_i = $row_i->get_name;
				my $name_j = $row_j->get_name;
				if ( $name_i=~/.*taxon\|([0-9]+)/) {
					$name_i =$1;
				}
				if ( $name_j=~/.*taxon\|([0-9]+)/) {
					$name_j =$1;
				}

				$name_i = $mt->find_node($name_i)->taxon_name;
				$name_j = $mt->find_node($name_j)->taxon_name;

				$identical++;
				print "\tseqs for " . $name_i . " and " . $name_j  . " are identical !\n";
			}
		}
	}
	$total_identical += $identical;
	print "Identical sequence pairs in cluster $file : $identical \n";
}
print "Total identical sequence pairs : $total_identical \n";
