#!/usr/bin/env perl

use Test::Most tests => 3;

use GAT;

my $gat = GAT->new();

    ok( defined $gat,      'GAT object is defined'); 
    ok( $gat->isa('GAT'),  'can make a GAT object' ); 
can_ok( $gat, qw( rest_client ), );
# my $rc = $gat->rest_client;
#    is( $rc->isa('REST::Client'), 'is our rest_client a REST::Client?' ); 


exit 0;
__END__

