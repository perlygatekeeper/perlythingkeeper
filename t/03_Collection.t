#!/usr/bin/env perl

use Test::Most tests => 39;
use Data::Dumper;

use Thingiverse;
use Thingiverse::Collection;

our $api_base = "/collections/";

my $id           = '2334425';
my $url          = $Thingiverse::api_uri_base . $Thingiverse::Collection::api_base . $id;
my $name         = "Boxes and Containers";
my $like_count   = 35;
my $things_count = 35;
my $creator_id   = 16273;
my $creator_name = 'perlygatekeeper';

# maximum of 30 things returned for collections?
$things_count = ( $things_count > $Thingiverse::pagination_maximum ) ? $Thingiverse::pagination_maximum : $things_count;

my $collection = Thingiverse::Collection->new( 'id' => $id );
# print Dumper($thing);

    ok( defined $collection,                 'Thingiverse::Collection  object is defined' ); 
    ok( $collection->isa('Thingiverse::Collection'), 'can make an Thingiverse::Collection object' ); 
can_ok( $collection, qw( id ),                  );
can_ok( $collection, qw( name ),                );
can_ok( $collection, qw( description ),         );
can_ok( $collection, qw( count ),               );
can_ok( $collection, qw( is_editable ),         );
can_ok( $collection, qw( url ),                 );
can_ok( $collection, qw( added ),               );
can_ok( $collection, qw( modified ),            );
can_ok( $collection, qw( creator ),             );
can_ok( $collection, qw( thumbnail ),           );
can_ok( $collection, qw( thumbnail_1 ),         );
can_ok( $collection, qw( thumbnail_2 ),         );
can_ok( $collection, qw( thumbnail_3 ),         );
can_ok( $collection, qw( things ),              );

    is( $collection->id,                $id,            'id           accessor' ); 
  like( $collection->name,              qr($name),      'name         accessor' ); 
  like( $collection->description,       qr(),           'description  accessor' ); 
    is( $collection->count,             $like_count,    'like_count   accessor' );
  like( $collection->is_editable,       qr(true|false), 'is_editable  accessor' ); 
    is( $collection->url,               $url,           'url          accessor' ); 
    ok( $collection->added->isa('DateTime'),            'registered is a DateTime object' ); 
    is( $collection->added->year,       2014,           'registered year  check' ); 
    is( $collection->added->month,      9,              'registered month check' ); 
    is( $collection->added->day ,       17,             'registered day   check' ); 
    ok( $collection->modified->isa('DateTime'),         'last_active is a DateTime object' );
    is( ref($collection->creator),      'HASH',         'creator is a User_Hash' ); 
    is( $collection->creator->{id},     $creator_id,    'creator id' );
    is( $collection->creator->{name},   $creator_name,  'creator name' );
  like( $collection->thumbnail,         qr(^(?i)https://thingiverse-production.*\.(jpg|png)), 'thumbnail    accessor' );
  like( $collection->thumbnail_1,       qr(^(?i)https://thingiverse-production.*\.(jpg|png)), 'thumbnail_1  accessor' );
  like( $collection->thumbnail_2,       qr(^(?i)https://thingiverse-production.*\.(jpg|png)), 'thumbnail_2  accessor' );
  like( $collection->thumbnail_3,       qr(^(?i)https://thingiverse-production.*\.(jpg|png)), 'thumbnail_3  accessor' );

    my $things = $collection->things;
    is( ref($things), 'Thingiverse::Thing::List', 'things accessor returns a Thingiverse::Thing::List' );
can_ok( $things, qw( count_things ), );
    is( $things->count_things, $things_count,     "tags contains $things_count tags" );
can_ok( $things, qw( get_things ), );
    my $first_things = $things->get_things(0);
    ok( $first_things->isa('Thingiverse::Thing'), 'first thing is a Thingiverse::Thing' );

if ( 0 ) {
  print "nothing\n";
}

exit 0;
__END__
{
  id: 2334425
  name: "Boxes and Containers"
  description: ""
  added: "2014-09-17T00:46:51+00:00"
  modified: "2014-09-17T00:47:03+00:00"
  creator: {
    id: 16273
    name: "perlygatekeeper"
    first_name: "Steve"
    last_name: "Parker"
    url: "https://api.thingiverse.com/users/perlygatekeeper"
    public_url: "http://www.thingiverse.com/perlygatekeeper"
    thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d3/5f/cb/0e/10/1524947_10202021360430593_1566936778_n_thumb_medium.jpg"
  }-
  url: "https://api.thingiverse.com/collections/2334425"
  count: 35
  is_editable: true
  thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_large.jpg"
  thumbnail_1: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_medium.jpg"
  thumbnail_2: "https://thingiverse-production.s3.amazonaws.com/renders/16/ae/be/7b/0e/IMG_20141223_215819_thumb_medium.jpg"
  thumbnail_3: "https://thingiverse-production.s3.amazonaws.com/renders/43/3c/d5/75/07/BoxOpenWithStopper2_thumb_medium.jpg"
}
