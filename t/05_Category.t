#!/usr/bin/env perl

use Test::Most tests => 18;
use Data::Dumper;

BEGIN {
    use_ok('Thingiverse');
    use_ok('Thingiverse::Category');
}

our $api_base = "/categories/";

my $name       = 'Tools'; # tools gives a count of 10435 while Tools gives 10439, odd?
my $url        = $Thingiverse::api_uri_base . $Thingiverse::Category::api_base . lc $name;
my $things_url = $Thingiverse::api_uri_base . $Thingiverse::Category::api_base . lc $name . '/things';
my $count      = 11166;
my $things     = ( $count > 30 ) ? 30 : $count;
my $children   = 4;

my $category = Thingiverse::Category->new( 'name' => $name );
# print Dumper($thing);

    ok( defined $category,          'Thingiverse::Category  object is defined' ); 
    ok( $category->isa('Thingiverse::Category'), 'can make an Thingiverse::Category object' ); 
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
cmp_ok( $category->count,     '>',    $count,                         'count        accessor' );
    is( $category->url,               $url,                           'url          accessor' ); 
    is( $category->things_url,        $things_url,                    'things_url   accessor' ); 
    is( @{$category->children},       $children,                      'children     accessor' );
    is( @{$category->things},         $things,                        'things       accessor' );

exit 0;
__END__
