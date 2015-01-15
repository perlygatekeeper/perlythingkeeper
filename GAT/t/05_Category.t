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
