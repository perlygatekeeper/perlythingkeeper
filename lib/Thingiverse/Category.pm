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

extends('Thingiverse::Object');

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

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/categories/',
        pk => { name => { isa => 'Str' } },
        fields => {
            count      => { isa => 'ThingiCount' },
            url        => { isa => 'Str' },
            things_url => { isa => 'Str' },
            thumbnail  => { isa => 'Str' },
        }
    },
);

has things => (
  isa        => 'Thingiverse::Thing::List',
  is         => 'ro',
  required   => 0,
  builder    => '_get_things_organized_under_category',
  lazy       => 1
);

sub _get_things_organized_under_category {
  my $self = shift;
  return Thingiverse::Thing::List->new(
    { api => 'categorized_by', term => $self->name , thingiverse => $self->thingiverse });
}

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





