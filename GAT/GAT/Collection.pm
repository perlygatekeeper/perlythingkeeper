package GAT::Collection;
use Moose;
use Carp;
use JSON;
use GAT::Types;

extends('GAT');
our $api_base = "/collections/";

has id            => ( isa => 'ID',                  is => 'ro', required => 1, );
has name          => ( isa => 'Str',                 is => 'ro', required => 0, );
has description   => ( isa => 'Str',                 is => 'ro', required => 0, );
has count         => ( isa => 'Int',                 is => 'ro', required => 0, );
has is_editable   => ( isa => 'Any',                 is => 'ro', required => 0, );
has url           => ( isa => 'Str',                 is => 'ro', required => 0, );
has added         => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has modified      => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
# has creator       => ( isa => 'User',                is => 'ro', required => 0, );
has creator       => ( isa => 'HashRef',             is => 'ro', required => 0, );
has thumbnail     => ( isa => 'Str',                 is => 'ro', required => 0, );
has thumbnail_1   => ( isa => 'Str',                 is => 'ro', required => 0, );
has thumbnail_2   => ( isa => 'Str',                 is => 'ro', required => 0, );
has thumbnail_3   => ( isa => 'Str',                 is => 'ro', required => 0, );
has things        => ( isa => 'ArrayRef[HashRef]',   is => 'ro', required => 0, builder => '_get_things_belonging_to_collection' );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $id;
  my $json;
  my $hash;
  if ( @_ == 1 && !ref $_[0] ) {
    $id = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}->{'id'} ) { # passed a hashref to a hash containing key 'id'
    $id = ${$_[0]}->{'id'};
  } elsif ( @_ == 2 && $_[0] eq 'id' ) { # passed a hashref to a hash containing key 'id'
    $id = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_from_collection_given_id($id);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_from_collection_given_id {
  my $id = shift;
  my $request = $api_base . $id;
  my $rest_client = GAT::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

sub _get_things_belonging_to_collection {
  return [ { key => 'value'  } ];
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

Class methods or things.pm as well as thing.pm?
latest
things

package GAT::user;
use Moose;
use Carp;
use JSON;
use GAT::Types;

extends('GAT');
our $api_base = "/users/";

has                id => ( isa => 'ThingID',             is => 'ro', required => 0, );
has    _original_json => ( isa => 'Str',                 is => 'ro', required => 0, );
has              name => ( isa => 'Str',                 is => 'ro', required => 1, );
has        first_name => ( isa => 'Str',                 is => 'ro', required => 0, );
has         last_name => ( isa => 'Str',                 is => 'ro', required => 0, );
has         full_name => ( isa => 'Str',                 is => 'ro', required => 0, );
has               url => ( isa => 'Str',                 is => 'ro', required => 0, ); # change to type URL once it's made
has        public_url => ( isa => 'Str',                 is => 'ro', required => 0, ); # change to type URL once it's made
has         thumbnail => ( isa => 'Str',                 is => 'ro', required => 0, );
has               bio => ( isa => 'Str',                 is => 'ro', required => 0, );
has          location => ( isa => 'Str',                 is => 'ro', required => 0, );
has        registered => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has       last_active => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has       cover_image => ( isa => 'Any',                 is => 'ro', required => 0, );
has        things_url => ( isa => 'Str',                 is => 'ro', required => 0, ); # change to type URL once it's made
has        copies_url => ( isa => 'Str',                 is => 'ro', required => 0, ); # change to type URL once it's made
has         likes_url => ( isa => 'Str',                 is => 'ro', required => 0, ); # change to type URL once it's made
has   default_license => ( isa => 'Str',                 is => 'ro', required => 0, );
has             email => ( isa => 'Str',                 is => 'ro', required => 0, );
has      is_following => ( isa => 'Boolean',             is => 'ro', required => 0, );
# has           likes => ( isa => 'ArrayRef[thing]',       is => 'ro', required => 0, , builder => '_get_things_for_user' );
# has     collections => ( isa => 'ArrayRef[collection]',  is => 'ro', required => 0, , builder => '_get_collections_for_user' );
# has       downloads => ( isa => 'ArrayRef[thing]',       is => 'ro', required => 0, , builder => '_get_downloads_for_user' );
# has     avatarimage => ( isa => 'Str',                   is => 'ro', required => 0, , builder => '_set_avatar_for_user' );
# has      coverimage => ( isa => 'Str',                   is => 'ro', required => 0, , builder => '_set_coverimage_for_user' );
