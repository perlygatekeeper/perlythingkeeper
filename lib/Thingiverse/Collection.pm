package Thingiverse::Collection;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use Thingiverse::Types;
use Thingiverse::Thing::List;
use Thingiverse::Collection::List;

extends('Thingiverse');

# ABSTRACT: Thingiverse Collection Object

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
* L<Thingiverse::Collection::List>
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

# two ways to get a list of Collections:
# /collections/                       with no added id, will give a list of the newest collections.
# /users/perlygatekeeper/collections  will give that user's collections

# two other calls to the API involving collections
# /collections/id                     give all information on collection designated by that id
# /collections/id/things              gives list of things belonging to that collection.

has _original_json => ( isa => 'Str',                      is => 'ro', required => 0, );

has id => (
  isa        => 'ID',
  is         => 'ro',
  required   => 1,
);

has thingiverse => (
  isa        => 'Thingiverse',
  is         => 'ro',
  required   => 1,
  handles    => [ qw(rest_client) ],
);

has [ qw( name description url thumbnail thumbnail_1 thumbnail_2 thumbnail_3 original_json) ]  => (
  isa        => 'Str',
  is         => 'ro',
  required   => 0,
  lazy_build => 1,
);

has count => (
  isa        => 'ThingiCount',
  is         => 'ro',
  required   => 0,
  lazy_build => 1,
);

has is_editable => (
  isa        => 'Any',
  is         => 'ro',
  required   => 0,
  lazy_build => 1,
);

has [ qw( added modified ) ] => (
  isa        => 'ThingiverseDateTime',
  is         => 'ro',
  required   => 0,
  coerce     => 1,
  lazy_build => 1,
);

has creator => (
  isa        => 'Thingiverse::User',
  is         => 'rw',
  required   => 0,
  coerce     => 1,
  lazy_build => 1,
);

has things => (
  isa        => 'Thingiverse::Thing::List',
  is         => 'ro',
  required   => 0,
# builder    => '_get_things_belonging_to_collection',
# lazy       => 1,
  lazy_build => 1,
);

sub _build_name {
	my $self = shift;
	return $self->content->{name};
}

sub _build_added {
	my $self = shift;
	return $self->content->{added};
}

sub _build_modified {
	my $self = shift;
	return $self->content->{modified};
}

sub _build_description {
	my $self = shift;
	return $self->content->{description};
}

sub _build_thumbnail {
	my $self = shift;
	return $self->content->{thumbnail};
}

sub _build_thumbnail_1 {
	my $self = shift;
	return $self->content->{thumbnail_1};
}

sub _build_thumbnail_2 {
	my $self = shift;
	return $self->content->{thumbnail_2};
}

sub _build_thumbnail_3 {
	my $self = shift;
	return $self->content->{thumbnail_3};
}

sub _build_url {
	my $self = shift;
	return $self->content->{url};
}

sub _build_count {
	my $self = shift;
	return $self->content->{count};
}

sub _build_is_editable {
	my $self = shift;
	return $self->content->{is_editable};
}

sub _build_things { # retrieve things belonging to collection
  my $self = shift;
  return Thingiverse::Thing::List->new(
		   { api => 'collected_in', term => $self->id  }
         );
}

sub _build_original_json {
	my $self = shift;
	my $request = $self->api_base() . $self->id();
	return $self->rest_client->GET($request)->responseConent;
}

sub _build_content {
	my $self = shift;
	return JSON::decode_json($self->orginal_json);
}

# ----
# 
# around BUILDARGS => sub {
#   my $orig = shift;
#   my $class = shift;
#   my $id;
#   my $json;
#   my $hash;
#   if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'id'}) {
#     print "I think I'll just be blessin' this collection: " . ${$_[0]}{'name'} . "\n" if ($Thingiverse::verbose);
#     print Dumper($_[0]) if ($Thingiverse::verbose > 1);
#     return $class->$orig(@_);
#   } elsif ( @_ == 1 && !ref $_[0] ) {
#     $id = $_[0];
#   } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'id'} ) { # passed a hashref to a hash containing key 'id'
#     $id = ${$_[0]}->{'id'};
#   } elsif ( @_ == 2 && $_[0] eq 'id' ) { # passed a hashref to a hash containing key 'id'
#     $id = $_[1];
#   } else {
#     return $class->$orig(@_);
#   }
#   $json = _get_collection_given_id($id);
#   $hash = decode_json($json);
#   $hash->{_original_json} = $json;
#   return $hash;
# };
# 
# sub _get_collection_given_id {
#   my $id = shift;
#   my $request = $api_base . $id;
#   my $rest_client = Thingiverse::_build_rest_client('');
#   my $response = $rest_client->GET($request);
#   my $content = $response ->responseContent;
#   return $content;
# }
# 
# ----


sub api_base {
  return '/collections/';
}

no Moose;
__PACKAGE__->meta->make_immutable;


sub newest {
  my $class = shift;
  return Thingiverse::Collection::List->new( 'newest' );
}

1;
__END__


{
  id: 2334425
  name: "Boxes and Containers"
  description: ""
  added: "2014-09-17T00:46:51+00:00"
  modified: "2014-09-17T00:47:03+00:00"
  creator: {
    id: 16273
    name: "perlygatekeeper"
    first_name: "Steve"
    last_name: "Parker"
    url: "https://api.thingiverse.com/users/perlygatekeeper"
    public_url: "http://www.thingiverse.com/perlygatekeeper"
    thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d3/5f/cb/0e/10/1524947_10202021360430593_1566936778_n_thumb_medium.jpg"
  }-
  url: "https://api.thingiverse.com/collections/2334425"
  count: 35
  is_editable: true
  thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_large.jpg"
  thumbnail_1: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_medium.jpg"
  thumbnail_2: "https://thingiverse-production.s3.amazonaws.com/renders/16/ae/be/7b/0e/IMG_20141223_215819_thumb_medium.jpg"
  thumbnail_3: "https://thingiverse-production.s3.amazonaws.com/renders/43/3c/d5/75/07/BoxOpenWithStopper2_thumb_medium.jpg"
}
