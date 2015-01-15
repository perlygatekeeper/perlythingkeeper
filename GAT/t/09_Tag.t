#!/usr/bin/env perl 

use Test::Most tests => 7 + 5;
use Data::Dumper;

use GAT;
use Thingiverse::Thing;

my $id         = '209078';
my $public_url = 'http://www.thingiverse.com/thing:'        . $id;
my $url        = $Thingiverse::api_uri_base . $GAT::Thing::api_base . $id;

my $thing = Thingiverse::Thing->new( 'id' => $id );
# print Dumper($thing);

    ok( defined $thing,            'Thingiverse::Thing object is defined' ); 
    ok( $thing->isa('Thingiverse::Thing'), 'can make an GAT::Thing object' ); 
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

#!/usr/bin/env perl

use Test::Most tests => 10 + 6;
use Data::Dumper;

use GAT;
use Thingiverse::Category;

our $api_base = "/categories/";

my $name       = 'Tools'; # tools gives a count of 10435 while Tools gives 10439, odd?
my $url        = $Thingiverse::api_uri_base . $GAT::Category::api_base . lc $name;
my $things_url = $Thingiverse::api_uri_base . $GAT::Category::api_base . lc $name . '/things';
my $count      = 10439;
my $things     = ( $count > 30 ) ? 30 : $count;
my $children   = 4;

my $category = Thingiverse::Category->new( 'name' => $name );
# print Dumper($thing);

    ok( defined $category,          'Thingiverse::Category  object is defined' ); 
    ok( $category->isa('Thingiverse::Category'), 'can make an GAT::Category object' ); 
can_ok( $category, qw( name ),                );
can_ok( $category, qw( count ),               );
can_ok( $category, qw( url ),                 );
can_ok( $category, qw( things_url ),          );
can_ok( $category, qw( thumbnail ),           );
can_ok( $category, qw( children ),            );
can_ok( $category, qw( things ),              );
can_ok( $category, qw( things_pagination),    );
# can_ok( $category, qw( list ),              );

  like( $category->name,              qr($name),                      'name         accessor' ); 
    is( $category->count,             $count,                         'count        accessor' );
    is( $category->url,               $url,                           'url          accessor' ); 
    is( $category->things_url,        $things_url,                    'things_url   accessor' ); 
    is( @{$category->children},       $children,                      'children     accessor' );
    is( @{$category->things},         $things,                        'things       accessor' );

exit 0;
__END__
