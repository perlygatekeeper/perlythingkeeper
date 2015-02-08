#!/usr/bin/env perl

use Test::Most tests => 5 + 4;
use Data::Dumper;

use Thingiverse;
use Thingiverse::Tag;

our $api_base = "/tags/";

my $name       = 'tool';
my $url        = $Thingiverse::api_uri_base . $Thingiverse::Tag::api_base . $name;
my $things_url = $Thingiverse::api_uri_base . $Thingiverse::Tag::api_base . $name . '/things';
my $count      = 1461;

my $tag = Thingiverse::Tag->new( 'name' => $name );
# print Dumper($thing);

    ok( defined $tag,          'Thingiverse::Tag  object is defined' ); 
    ok( $tag->isa('Thingiverse::Tag'), 'can make an Thingiverse::Tag object' ); 
can_ok( $tag, qw( name ),                );
can_ok( $tag, qw( count ),               );
can_ok( $tag, qw( url ),                 );
can_ok( $tag, qw( things_url ),          );
# can_ok( $tag, qw( things ),              );

  like( $tag->name,              qr($name),                      'name         accessor' ); 
    is( $tag->count,             $count,                         'like_count   accessor' );
    is( $tag->url,               $url,                           'url          accessor' ); 
    is( $tag->things_url,        $things_url,                    'things_url   accessor' ); 
#   is( @{$tag->things},         $count,                         'things       accessor' );

exit 0;
__END__
