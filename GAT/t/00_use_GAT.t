#!/usr/bin/env perl

use Test::Most tests => 2;

use GAT;

my $gat = GAT->new();

ok( defined $gat ); 
ok( $gat->isa('GAT') ); 

exit 0;
__END__
