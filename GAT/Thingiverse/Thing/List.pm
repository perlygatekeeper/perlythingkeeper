package Thingiverse::Thing::List;
use Moose;
use Carp;
use JSON;
use Thingiverse;
use Thingiverse::Types;

# each of these 9 API's returns a list of Thingiverse::Things
# and will benefit from the traits of ['Array'] provided by
# Moose::Meta::Attribute::Native::Trait::Array
# four of these API's need additional information
# search API needs a search term
# ancestors, derivates and prints  APIs all need a thing_id

our $api_bases = {
  things         => "/things/",
  search         => "/search/%s",
  newest         => "/newest/",
  popular        => "/popular/",
  featured       => "/featured/",
  copies         => '/copies',
  ancestors      => '/things/%s/ancestors',
  derivatives    => '/things/%s/derivatives',
  prints         => '/things/%s/prints',
  categorized_by => '/categories/%s/things',
  collected_in   => '/collections/%s/things',
  tagged_as      => '/tags/%s/things',
};

has things_api  => ( isa => 'Things_API',              is => 'ro', required => 1, );
has search_term => ( isa => 'Str',                     is => 'ro', required => 0, );
has thing_id    => ( isa => 'ID',                      is => 'ro', required => 0, );
has request_url => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination  => ( isa => 'Thingiverse::Pagination', is => 'ro', required => 0, );

has things  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Thing]',
  required => 0,
  handles  => {
    all_things      => 'elements',
    add_things      => 'push',
    map_things      => 'map',
    filter_things   => 'grep',
    find_things     => 'grep',
    get_things      => 'get',
    join_things     => 'join',
    count_things    => 'count',
    has_things      => 'count',
    has_no_things   => 'is_empty',
    sorted_things   => 'sort',
  },
# lazy => 1,
);

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $api, $term, $things, $thing_id, $json, $hash, $request );
  if ( @_ == 1 && !ref $_[0] ) {
    $api = $_[0];
  } elsif ( @_ == 2 && $_[0] =~ m'api'i ) {
    $api = $_[1];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'api'} ) { # passed a hashref to a hash containing key 'api'
    $api      = ${$_[0]}{'api'};
    $term     = ${$_[0]}{'term'};
    $thing_id = ${$_[0]}{'thing_id'};
  } else {
# not sure what to do here
    return $class->$orig(@_);
  }
# Now decide what to do.
  if      ( $api =~ qr(things|newest|featured|popular|copies) ) {
    $request = $api_bases->{$api};
  } elsif ( $api =~ qr(ancestors|derivatives|prints) ) {
    $request = sprintf $api_bases->{$api}, $thing_id;
  } elsif ( $api =~ qr(search|categor|collect|tag) ) {
    $request = sprintf $api_bases->{$api}, $term;
  } else {
    die "API specified ($api) not know to return list of things.";
  }
  $json = _get_from_thingiverse($request);
  $things = decode_json($json);
  if ( ref($things) eq 'ARRAY' ) {
    foreach ( @{$things} ) {
      $_->{creator}{just_bless}=1;
      $_->{creator} = Thingiverse::User->new($_->{creator});
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Thing->new($_);
    }
  }
  $hash->{things}      = $things;
  $hash->{things_api}  = $api;
  $hash->{request_url} = $request;
  $hash->{term}        = $term if ( $term ); 
  $hash->{thing_id}    = $thing_id    if ( $thing_id ); 
  return $hash;
};

sub _get_from_thingiverse {
  my $request = shift;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
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

Other objects generate a List of things as well:
categories
collections
tags

Need Pagination work for this one.

Could do the same (or something similar) for Categories, Collections, Tags, Images and Files.

