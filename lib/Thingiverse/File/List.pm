package Thingiverse::File::List;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse::Types;

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

=method method_x

This method does something experimental.

=method method_y

This method returns a reason.

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
* L<Thingiverse::Cache>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::Tag>
* L<Thingiverse::Tag::List>
* L<Thingiverse::Category>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Comment>
* L<Thingiverse::File>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

# each of these 9 API's returns a list of Thingiverse::Things
# and will benefit from the traits of ['Array'] provided by
# Moose::Meta::Attribute::Native::Trait::Array
# four of these API's need additional information
# search API needs a search term
# ancestors, derivates and prints  APIs all need a thing_id

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

has things_api  => ( isa => 'Things_API',              is => 'ro', required => 1, );
has thing_id    => ( isa => 'ID',                      is => 'ro', required => 0, );
has search_term => ( isa => 'Str',                     is => 'ro', required => 0, );
has request_url => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination  => ( isa => 'Thingiverse::Pagination', is => 'ro', required => 0, );

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

Could do the same (or something similar) for Categories, Collections, Tags, Images and Files.


  use Switch;
    switch ($val) {
      case 1          { print "number 1" }
      case "a"        { print "string a" }
      case [1..10,42] { print "number in list" }
      case (@array)   { print "number in list" }
      case /\w+/      { print "pattern" }
      case qr/\w+/    { print "pattern" }
      case (%hash)    { print "entry in hash" }
      case (\%hash)   { print "entry in hash" }
      case (\&sub)    { print "arg to subroutine" }
      else            { print "previous case not true" }
    }
