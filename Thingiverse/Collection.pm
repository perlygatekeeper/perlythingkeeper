package Thingiverse::Collection;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;

extends('Thingiverse');
our $api_base = "/collections/";

has id             => ( isa => 'ID',                  is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',                 is => 'ro', required => 0, );
has name           => ( isa => 'Str',                 is => 'ro', required => 0, );
has description    => ( isa => 'Str',                 is => 'ro', required => 0, );
has count          => ( isa => 'ThingiCount',         is => 'ro', required => 0, );
has is_editable    => ( isa => 'Any',                 is => 'ro', required => 0, );
has url            => ( isa => 'Str',                 is => 'ro', required => 0, );
has added          => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has modified       => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has creator        => ( isa => 'User_Hash',           is => 'rw', required => 0, coerce => 1 );
has thumbnail      => ( isa => 'Str',                 is => 'ro', required => 0, );
has thumbnail_1    => ( isa => 'Str',                 is => 'ro', required => 0, );
has thumbnail_2    => ( isa => 'Str',                 is => 'ro', required => 0, );
has thumbnail_3    => ( isa => 'Str',                 is => 'ro', required => 0, );
has things         => ( isa => 'ArrayRef[HashRef]',   is => 'ro', required => 0, builder => '_get_things_belonging_to_collection' );

# two ways to get a list of Collections:
# /collections/                       with no added id, will give a list of the newest collections.
# /users/perlygatekeeper/collections  will give that user's collections
# /collections/id                     give all information on collection designated by that id
# /collections/id/things              gives list of things belonging to that collection.

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $id;
  my $json;
  my $hash;
  if ( @_ == 1 && !ref $_[0] ) {
    $id = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'id'} ) { # passed a hashref to a hash containing key 'id'
    $id = ${$_[0]}->{'id'};
  } elsif ( @_ == 2 && $_[0] eq 'id' ) { # passed a hashref to a hash containing key 'id'
    $id = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_collection_given_id($id);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_collection_given_id {
  my $id = shift;
  my $request = $api_base . $id;
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

sub _get_things_belonging_to_collection {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'search', term => $self->id  } );

}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
client_id( q(c587f0f2ee04adbe719b) );
access_token( q(b053a0798c50a84fbb80e66e51bba9c4) );
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


From irc.freenode.org on Sat Jan 10 2015
perlygatekeeper
9:46 ok, so I have a situation, where my in REST API consuming Classes, I collect information on a thing, one of the attributes of the thing is the creator of the thing, so I have 'has creator => (isa => "APP::User")'  but I don't need to call a builder, it is populated as a JSON encoded Str, my question is " Can one set up a coercion for a class type like APP::User
ether
9:51 my $app_user_type = subtype as class_type('App::User'); coerce $app_user_type, from 'Str', via {  code ehre that turns a json str into a class name }
9:51 see Moose::Util::TypeConstraints for more
