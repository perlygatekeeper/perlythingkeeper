#!/usr/bin/env perl

use Test::Most tests => 3;
use Data::Dumper;

use GAT::user;

my $user = GAT::user->new( 'name' => 'perlygatekeeper' );

ok( defined $user ); 
ok( $user->isa('GAT::user') ); 
ok( $user->id == '16273' ); 
print Dumper($user);

exit 0;
__END__
