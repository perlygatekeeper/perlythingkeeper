package GAT::Category;
use Moose;
use Carp;
use JSON;
use GAT::Types;
# use GAT::User;

extends('GAT');
our $api_base = "/categories/";

has name       => ( isa => 'Str',               is => 'ro', required => 1, );
has url        => ( isa => 'Str',               is => 'ro', required => 0, );
has thumbnail  => ( isa => 'Str',               is => 'ro', required => 0, );
has count      => ( isa => 'ThingiCount',       is => 'ro', required => 0, );
has things_url => ( isa => 'Str',               is => 'ro', required => 0, ); # change to type URL once it's made
has children   => ( isa => 'ArrayRef[HashRef]', is => 'ro', required => 0, );
has things     => ( isa => 'ArrayRef[HashRef]', is => 'ro', required => 0, builder => '_get_things_organized_under_category' );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && !ref $_[0] ) {
    # return $class->$orig( name => $_[0] );
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}->{'name'} ) { # passed a hashref to a hash containing key 'name'
    $name = ${$_[0]}->{'name'};
  } elsif ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
    $name = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_category_given_name($name);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_category_given_name {
  my $name = shift;
  my $request = $api_base . $name;
  my $rest_client = GAT::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_organized_under_category {
  my $self = shift;
  my $request = $api_base . $self->name . '/things';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  return $return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
special methods

list
things

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
