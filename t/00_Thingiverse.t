#!/usr/bin/env perl

use Test::Most tests => 7;

BEGIN {
    use_ok('Thingiverse');
}

my $thingiverse = Thingiverse->new();

    ok( defined $thingiverse,      'Thingiverse object is defined'); 
    ok( $thingiverse->isa('Thingiverse'),  'can make a Thingiverse object' ); 
can_ok( $thingiverse, qw( rest_client ), );
 my $rc = $thingiverse->rest_client;
    ok( $rc->isa('REST::Client'), 'is our rest_client a REST::Client?' ); 
can_ok( $thingiverse, qw( verbosity ), );
cmp_ok( $thingiverse->verbosity, '==', '0', 'default verbosity is 0', );
$thingiverse->verbosity(2);
cmp_ok( $thingiverse->verbosity, '==', '2', 'set verbosity to 2', );


exit 0;
__END__

