#!/usr/bin/env perl 

use Test::Most tests => 14;
use Data::Dumper;

BEGIN {
    use_ok('Thingiverse');
    use_ok('Thingiverse::Thing');
}

my $id         = '209078';
my $public_url = 'http://www.thingiverse.com/thing:'        . $id;
my $url        = $Thingiverse::api_uri_base . Thingiverse::Thing->api_base . $id;

my $thing = Thingiverse::Thing->new( 'id' => $id );
# print Dumper($thing);

    ok( defined $thing,            'Thingiverse::Thing object is defined' ); 
    ok( $thing->isa('Thingiverse::Thing'), 'can make an Thingiverse::Thing object' ); 
can_ok( $thing, qw( id ),                  );
can_ok( $thing, qw( name ),                );
can_ok( $thing, qw( public_url ),          );
can_ok( $thing, qw( url ),                 );
can_ok( $thing, qw( images_url ),          );

    is( $thing->id,                  $id,                              'id         accessor' ); 
  like( $thing->name,                qr((?i:circular diz fiber tool)), 'name       accessor' ); 
    is( $thing->public_url,          $public_url,                      'public_url accessor' ); 
    is( $thing->url,                 $url,                             '       url accessor' ); 
    is( $thing->images_url,          $url . '/images',                 'images_url accessor' ); 

if ( 0 ) {
  print "nothing\n";
}

exit 0;
__END__

special methods:
  publish
  like
  unlike
  package
  threadedcomments

Class methods or things.pm as well as thing.pm?
  newest
  featured
  popular

  search

