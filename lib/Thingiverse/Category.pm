package Thingiverse::Category;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse::Types;
use Thingiverse::Thing::List;
# use Thingiverse::User;

extends('Thingiverse');

# ABSTRACT: Thingiverse Category Object

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
* L<Thingiverse::Collection>
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

has name => (
  isa        => 'Str',
  is         => 'ro',
  required   => 1,
);

has thingiverse => (
  isa        => 'Thingiverse',
  is         => 'ro',
  required   => 1,
  default    => sub { return Thingiverse->new() },
  handles    => [ qw(rest_client) ],
);

has count => (
  isa        => 'ThingiCount',
  is         => 'ro',
  lazy_build => 1,
);

has [qw/url things_url thumbnail original_json/] => (
  isa        => 'Str',
  is         => 'ro',
  lazy_build => 1,
);

has things => (
  isa        => 'Thingiverse::Thing::List',
  is         => 'ro',
  required   => 0,
  builder    => '_get_things_organized_under_category',
  lazy       => 1
);

# has children          => ( isa => 'ArrayRef[HashRef]', is => 'ro', required => 0, );
# has things_pagination => ( isa => 'HashRef[Str]',      is => 'rw', required => 0  );

has content => (
  isa        => 'HashRef',
  is         => 'ro',
  lazy_build => 1,
);

# Attribute builders, called by users via Moose, referencing content

sub _build_count { 
  my $self = shift;
  return $self->content->{count};
}

sub _build_url {
  my $self = shift;
  return $self->content->{url};
}

sub _build_things_url {
  my $self = shift;
  return $self->content->{things_url};
}

# Content generator, called by attribute builders, referencing orginal_json

sub _build_content {
  my $self = shift;
  return JSON::decode_json($self->original_json);
}

# original_json retrieval from REST API, called by content generator, referencing rest_client

sub _build_original_json {
  my $self        = shift;
  my $request     = $self->api_base() . $self->name();
  return $self->rest_client->GET($request)->responseContent;
}

sub _get_things_organized_under_category {
  my $self = shift;
  return Thingiverse::Thing::List->new(
    { api => 'categorized_by', term => $self->name });
}

sub api_base {
  return '/categories/';
}

# -----
# around BUILDARGS => sub {
#   my $orig = shift;
#   my $class = shift;
#   my $name;
#   my $json;
#   my $hash;
#   if ( @_ == 1 && !ref $_[0] ) {
#     # return $class->$orig( name => $_[0] );
#     $name = $_[0];
#   } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'name'} ) { # passed a hashref to a hash containing key 'name'
#     $name = ${$_[0]}->{'name'};
#   } elsif ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
#     $name = $_[1];
#   } else {
#     return $class->$orig(@_);
#   }
#   $json = _get_category_given_name($name);
#   $hash = decode_json($json);
#   $hash->{_original_json} = $json;
#   return $hash;
# };
# 
# sub _get_category_given_name {
#   my $name = shift;
#   my $request = $api_base . $name;
#   my $rest_client = Thingiverse::_build_rest_client('');
#   my $response = $rest_client->GET($request);
#   my $content = $response->responseContent;
#   return $content;
# }
# 
# sub _get_things_organized_under_category {
#   my $self = shift;
#   my $request = $api_base . $self->name . '/things'; # should be a Thingiverse::Thing::List
#   my $response = $self->rest_client->GET($request);
#   my $content = $response->responseContent;
#   my $link_header = $response->responseHeader('Link');
#   my $return = decode_json($content);
#   if ($link_header =~ /rel=.(first|last|next|prev)/) {
#     my $pagination;
#     foreach my $link ( split( /,\s*/, $link_header ) ) {
#       my ($page_url, $page_label) = ( $link =~ /<([^>]+)>;\s+rel="([^"]+)"/);
#       $pagination->{$page_label}=$page_url;
#     }
#     $self->things_pagination($pagination);
#   }
#   return $return;
# }
# -----

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
aliases:
subcategories for children

special methods

list
things

Response Header for things call:
Link: <https://api.thingiverse.com/categories/Tools/things?page=2>; rel="next", <https://api.thingiverse.com/categories/Tools/things>; rel="first", <https://api.thingiverse.com/categories/Tools/things?page=348>; rel="last" 

response for list
Response Header for things call:
Link: <https://api.thingiverse.com/categories>; rel="first", <https://api.thingiverse.com/categories?page=1>; rel="last" 
[10]
0:  {
  name: "3D Printing"
  url: "https://api.thingiverse.com/categories/3d-printing"
}-
1:  {
  name: "Art"
  url: "https://api.thingiverse.com/categories/art"
}-
2:  {
  name: "Fashion"
  url: "https://api.thingiverse.com/categories/fashion"
}-
3:  {
  name: "Gadgets"
  url: "https://api.thingiverse.com/categories/gadgets"
}-
4:  {
  name: "Hobby"
  url: "https://api.thingiverse.com/categories/hobby"
}-
5:  {
  name: "Household"
  url: "https://api.thingiverse.com/categories/household"
}-
6:  {
  name: "Learning"
  url: "https://api.thingiverse.com/categories/learning"
}-
7:  {
  name: "Models"
  url: "https://api.thingiverse.com/categories/models"
}-
8:  {
  name: "Tools"
  url: "https://api.thingiverse.com/categories/tools"
}-
9:  {
  name: "Toys & Games"
  url: "https://api.thingiverse.com/categories/toys-and-games"
}





