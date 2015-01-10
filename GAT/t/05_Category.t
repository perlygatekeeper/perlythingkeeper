#!/usr/bin/env perl

use Test::Most tests => 8 + 5;
use Data::Dumper;

use GAT;
use GAT::Category;

our $api_base = "/categories/";

my $name       = 'Tools'; # tools gives a count of 10435 while Tools gives 10439, odd?
my $url        = $GAT::api_uri_base . $GAT::Category::api_base . lc $name;
my $things_url = $GAT::api_uri_base . $GAT::Category::api_base . lc $name . '/things';
my $count      = 10439;
my $children   = 4;

my $category = GAT::Category->new( 'name' => $name );
# print Dumper($thing);

    ok( defined $category,          'GAT::Category  object is defined' ); 
    ok( $category->isa('GAT::Category'), 'can make an GAT::Category object' ); 
can_ok( $category, qw( name ),                );
can_ok( $category, qw( count ),               );
can_ok( $category, qw( url ),                 );
can_ok( $category, qw( things_url ),          );
can_ok( $category, qw( thumbnail ),           );
can_ok( $category, qw( children ),            );
# can_ok( $category, qw( list ),              );
# can_ok( $category, qw( things ),              );

  like( $category->name,              qr($name),                      'name         accessor' ); 
    is( $category->count,             $count,                         'count        accessor' );
    is( $category->url,               $url,                           'url          accessor' ); 
    is( $category->things_url,        $things_url,                    'things_url   accessor' ); 
    is( @{$category->children},       $children,                      'children     accessor' );
#   is( @{$category->things},         $count,                         'things       accessor' );

exit 0;
__END__
