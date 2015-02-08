#!/usr/bin/env perl 

use Test::Most tests => 13;
use Data::Dumper;

BEGIN {
    use_ok('Thingiverse');
    use_ok('Thingiverse::Thing');
    use_ok('Thingiverse::Tag');
}

my $api_base = '/tags/';

my $name           = 'banana';
my $url            = $Thingiverse::api_uri_base . $api_base . $name;
my $expected_count = '24';
my $things_url     = $url . '/things';

my $tag = Thingiverse::Tag->new( 'name' => $name );
# print Dumper($tag);

    ok( defined $tag,            'Thingiverse::Thing object is defined' ); 
    ok( $tag->isa('Thingiverse::Tag'), 'can make an Thingiverse::Tag object' ); 
can_ok( $tag, qw( name ),       );
can_ok( $tag, qw( url ),        );
can_ok( $tag, qw( count ),      );
can_ok( $tag, qw( things_url ), );

  like( $tag->name,             qr((?i:banana)),  'name       accessor' ); 
cmp_ok( $tag->count,      "==", $expected_count,  'count      accessor' ); 
    is( $tag->url,              $url,             'url        accessor' ); 
    is( $tag->things_url,       $url . '/things', 'things_url accessor' ); 

# need yet to test tags/NAME/things and Tag/List.pm yet.

if ( 0 ) {
  print "notag\n";
}

exit 0;
__END__
