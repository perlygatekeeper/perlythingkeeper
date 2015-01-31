#!/usr/bin/env perl 

use Test::Most;
use Data::Dumper;

use Thingiverse;
use Thingiverse::Thing;

my $newest_things = Thingiverse::Thing->newest( );
# print Dumper($newest_things);

    ok( defined $newest_things,            'Thingiverse::Thing object is defined' ); 
can_ok( $newest_things, qw( things ),      );
can_ok( $newest_things, qw( things_api ),  );
can_ok( $newest_things, qw( search_term ), );
can_ok( $newest_things, qw( thing_id ),    );
can_ok( $newest_things, qw( request_url ), );

    is( $newest_things->things_api,    'newest',     "api 'things'   given to Thingiverse::Thing::List was correct", );
    is( $newest_things->request_url,   '/newest/',   "correct request_url was generated", );

$newest_things = Thingiverse::Thing->popular( );
    is( $newest_things->things_api,    'popular',    "api 'popular'  given to Thingiverse::Thing::List was correct", );
    is( $newest_things->request_url,   '/popular/',  "correct request_url was generated", );

$newest_things = Thingiverse::Thing->featured( );
    is( $newest_things->things_api,    'featured',   "api 'featured' given to Thingiverse::Thing::List was correct", );
    is( $newest_things->request_url,   '/featured/', "correct request_url was generated", );

done_testing;

exit 0;
__END__

package Thingiverse::Thing::List;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;


our $api_bases = {
  things      => "/things/",
  search      => "/search/%s",
  newest      => "/newest/",
  popular     => "/popular/",
  featured    => "/featured/",
  copies      => '/copies',
  ancestors   => '/things/%s/ancestors',
  derivatives => '/things/%s/derivatives',
  prints      => '/things/%s/prints',
};

has things_api  => ( isa => 'Things_API', is => 'ro', required => 1, );
has thing_id    => ( isa => 'ID',         is => 'ro', required => 0, );
has search_term => ( isa => 'Str',        is => 'ro', required => 0, );
has request_url => ( isa => 'Str',        is => 'ro', required => 0, );

has things  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Thing]',
  required => 0,
  handles  => {
    all_sizes      => 'elements',
    add_sizes      => 'push',
    map_sizes      => 'map',
    filter_sizes   => 'grep',
    find_sizes     => 'grep',
    get_sizes      => 'get',
    join_sizes     => 'join',
    count_sizes    => 'count',
    has_sizes      => 'count',
    has_no_sizes   => 'is_empty',
    sorted_sizes   => 'sort',
  },
# lazy => 1,
);

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $api, $search_term, $things, $thing_id, $json, $hash, $request );
  if ( @_ == 1 && !ref $_[0] ) {
    $api = $_[0];
  } elsif ( @_ == 2 && $_[0] =~ m'api'i ) {
    $api = $_[1];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'api'} ) { # passed a hashref to a hash containing key 'name'
    $api         = ${$_[0]}->{'api'};
    $search_term = ${$_[0]}->{'search_term'};
    $thing_id    = ${$_[0]}->{'thing_id'};
  } else {
# not sure what to do here
    return $class->$orig(@_);
  }
# Now decide what to do.
  if      ( $api =~ qr(things|newest|featured|popular|copies) ) {
    $request = $api_bases->{$api};
  } elsif ( $api =~ qr(ancestors|derivatives|prints) ) {
    $request = sprintf $api_bases->{$api}, $thing_id;
  } elsif ( $api eq 'search' ) {
    $request = sprintf $api_bases->{$api}, $search_term;
  } else {
    die "API specified ($api) not know to return list of things.";
  }
  $json = _get_from_thingiverse($request);
  $things = decode_json($json);
  if ( ref($things) eq 'ARRAY' ) {
    foreach ( @{$things} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Thing->new($_);
    }
  }
  $hash->{things}      = $things;;
  $hash->{things_api}  = $api;;
  $hash->{request_url} = $request;
  $hash->{search_term} = $search_term if ( $search_term ); 
  $hash->{thing_id}    = $thing_id    if ( $thing_id ); 
  return $hash;
};

sub _get_from_thingiverse {
  my $request = shift;
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

# Related Things
ancestors
derivatives
copies
prints

# Class methods or things.pm as well as thing.pm?
# returns lists of Things
newest
featured
popular

search

things (without an id)

Need Pagination work for this one.

