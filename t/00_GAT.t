#!/usr/bin/env perl

use Test::Most tests => 3;

use Thingiverse;

my $gat = Thingiverse->new();

    ok( defined $gat,      'Thingiverse object is defined'); 
    ok( $gat->isa('Thingiverse'),  'can make a Thingiverse object' ); 
can_ok( $gat, qw( rest_client ), );
# my $rc = $gat->rest_client;
#    is( $rc->isa('REST::Client'), 'is our rest_client a REST::Client?' ); 


exit 0;
__END__

