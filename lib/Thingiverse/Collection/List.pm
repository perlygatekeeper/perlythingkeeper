package Thingiverse::Collection::List;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse;
use Thingiverse::Types;
use Thingiverse::Pagination;
use Thingiverse::Collection;

our $api_bases = {
  created_by => '/users/%s/collections', # collections created by user
  newest     => '/collections',
};

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

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
* L<Thingiverse::Comment>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has collections_api => ( isa => 'Collections_API',         is => 'ro', required => 0, );
has user_id         => ( isa => 'ID',                      is => 'ro', required => 0, );
has request_url     => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination      => ( isa => 'Thingiverse::Pagination', is => 'ro', required => 0, );

has collections  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Collection]',
  required => 0,
  handles  => {
    all_collections      => 'elements',
    add_collections      => 'push',
    map_collections      => 'map',
    filter_collections   => 'grep',
    find_collections     => 'grep',
    get_collections      => 'get',
    join_collections     => 'join',
    count_collections    => 'count',
    has_collections      => 'count',
    has_no_collections   => 'is_empty',
    sorted_collections   => 'sort',
  },
# lazy => 1,
);

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $api, $term, $collections, $username, $json, $hash, $from_thingiverse,
       $request, $response, $link_header, $total_count, $pagination );

  if ( @_ == 0 ) {
    $api = 'newest';
  } elsif ( @_ == 1 && !ref $_[0] ) {
    $api = $_[0];
  } elsif ( @_ == 2 && $_[0] =~ m'api'i ) {
    $api = $_[1];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'api'} ) { # passed a hashref to a hash containing key 'api'
    $api      = ${$_[0]}{'api'};
    $username = ${$_[0]}{'username'};
  } else {
# not sure what to do here
    return $class->$orig(@_);
  }
# Now decide what to do.
  if      ( $api =~ qr(newest) ) {
    $request = $api_bases->{$api};
  } elsif ( $api =~ qr(created_by) ) {
    $request = sprintf $api_bases->{$api}, $username;
  } else {
    die "API specified ($api) not know to return list of collections.";
  }

  $from_thingiverse = _get_from_thingiverse($request);
  $response         = $from_thingiverse->{response};
  $json             = $response->responseContent;
  $collections      = decode_json($json);
  $pagination       = Thingiverse::Pagination->new( { response => $response, page => 1 } );
  if ( ref($collections) eq 'ARRAY' ) {
    foreach ( @{$collections} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Collection->new($_);
    }
  }
  $link_header = $response->responseHeader('Link');
  $hash->{collections}     = $collections;
  $hash->{collections_api} = $api;
  $hash->{request_url}     = $request;
  $hash->{username}        = $username if ( $username );
  $hash->{rest_client}     = $from_thingiverse->{rest_client};
  return $hash;
};

# NEED A TRIGGER FOR CHANGE IN Pagination to make a new call to thingiverse!!!!

sub _get_from_thingiverse {
  my $request = shift;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $rest_client = Thingiverse::_build_rest_client('');
  my $response = $rest_client->GET($request);
  return { response => $response, rest_client => $rest_client };
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

