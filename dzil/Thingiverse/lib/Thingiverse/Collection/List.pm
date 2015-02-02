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

our $api_bases = {
  created_by => '/users/%s/collections', # collections created by user
  list       => '/collections',
};

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
* L<Thingiverse::User::List>
* L<Thingiverse::Cache>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::Tag>
* L<Thingiverse::Tag::List>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Category>
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

our $api_bases = {
  liked_by  => '/things/%s/liked',   # users that liked this thing
};

has users_api   => ( isa => 'Users_API',               is => 'ro', required => 0, );
has thing_id    => ( isa => 'ID',                      is => 'ro', required => 0, );
has request_url => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination  => ( isa => 'Thingiverse::Pagination', is => 'ro', required => 0, );

has users  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::User]',
  required => 0,
  handles  => {
    all_users      => 'elements',
    add_users      => 'push',
    map_users      => 'map',
    filter_users   => 'grep',
    find_users     => 'grep',
    get_users      => 'get',
    join_users     => 'join',
    count_users    => 'count',
    has_users      => 'count',
    has_no_users   => 'is_empty',
    sorted_users   => 'sort',
  },
# lazy => 1,
);

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $api, $term, $users, $user_name, $json, $hash, $request, $response, $link_header, $total_count, $pagination );
  if ( @_ == 1 && !ref $_[0] ) {
    $api = $_[0];
  } elsif ( @_ == 2 && $_[0] =~ m'api'i ) {
    $api = $_[1];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'api'} ) { # passed a hashref to a hash containing key 'api'
    $api      = ${$_[0]}{'api'};
    $thing_id = ${$_[0]}{'thing_id'};
    $term     = ${$_[0]}{'term'};
  } else {
# not sure what to do here
    return $class->$orig(@_);
  }
# Now decide what to do.
  if      ( $api =~ qr(liked) ) {
    $request = sprintf $api_bases->{$api}, $thing_id;
  } elsif ( $api =~ qr(qqq|xxx) ) {
    $request = sprintf $api_bases->{$api}, $thing_id;
  } else {
    die "API specified ($api) not know to return list of users.";
  }
  $response   = _get_from_thingiverse($request);
  $json       = $response)->responseContent;
  $users      = decode_json($json);
  $pagination = Thingverse::Pagination( { response => $response, page => 1 } );
  if ( ref($users) eq 'ARRAY' ) {
    foreach ( @{$users} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::User->new($_);
    }
  }
  my $link_header = $response->responseHeader('Link');
  $hash->{users}       = $users;
  $hash->{users_api}   = $api;
  $hash->{request_url} = $request;
  $hash->{thing_id}    = $thing_id if ( $thing_id ); 
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
