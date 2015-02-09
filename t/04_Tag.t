#!/usr/bin/env perl

use Test::Most tests => 12;
use Data::Dumper;

BEGIN {
  use_ok('Thingiverse');
  use_ok('Thingiverse::Tag');
}

my $name = 'tool';
my $url  = $Thingiverse::api_uri_base . Thingiverse::Tag->api_base . $name;
my $things_url
  = $Thingiverse::api_uri_base . Thingiverse::Tag->api_base . $name . '/things';
my $count = 1461;

my $tag = Thingiverse::Tag->new(
  name        => $name,
  thingiverse => Thingiverse->new,
);

# print Dumper($tag);

ok(defined $tag,                  'Thingiverse::Tag  object is defined');
ok($tag->isa('Thingiverse::Tag'), 'can make an Thingiverse::Tag object');
can_ok($tag, qw( name ),);
can_ok($tag, qw( count ),);
can_ok($tag, qw( url ),);
can_ok($tag, qw( things_url ),);

# can_ok( $tag, qw( things ),              );

like($tag->name, qr($name), 'name         accessor');
cmp_ok($tag->count, '>', $count, 'like_count   accessor');
is($tag->url,        $url,        'url          accessor');
is($tag->things_url, $things_url, 'things_url   accessor');

#   is( @{$tag->things},         $count,                         'things       accessor' );

exit 0;
__END__
