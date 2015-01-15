package Thingiverse::Image;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;
use Thingiverse::SizedImage;

extends('GAT');
our $api_base = "/thing/%d/images/%d";

has thing_id             => ( isa => 'ID',                         is => 'ro', required => 1, );
has id                   => ( isa => 'ID',                         is => 'ro', required => 1, );
has _original_json       => ( isa => 'Str',                        is => 'ro', required => 0, );
has name                 => ( isa => 'Str',                        is => 'ro', required => 0, );
has url                  => ( isa => 'Str',                        is => 'ro', required => 0, );
# has sizes                => ( isa => 'ArrayRef[Thingiverse::SizedImage]',  is => 'ro', required => 0, builder => '_get_sized_versions_of_this_image' );

has sizes  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::SizedImage]',
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
  builder => '_get_sized_versions_of_this_image',
);

# need both the thing_id and the image_id to make an API call
around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $thing_id;
  my $image_id;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'id'} && ${$_[0]}{'thing_id'} && not exists ${$_[0]}{'sizes'} ) {
    $thing_id = ${$_[0]}{'thing_id'};
    $image_id = ${$_[0]}{'id'};
  } elsif ( @_ == 2 ) { # passed two id's, thing_id and image_id
    $thing_id = $_[0];
    $image_id = $_[1];
  } else {
    my $return = $class->$orig(@_); # almost all Thingiverse::Image creatations will be from an predefined hash from a GAT::Thing or GAT::Collection.
	$return = _get_sized_versions_of_this_image($return);;
	return $return;
  }
  $json = _get_from_thingi_given_id($image_id,$thing_id);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_sized_versions_of_this_image {
  my $self = shift;
  my $sizes = $self->{sizes};
  if ( ref($sizes) eq 'ARRAY' ) {
    foreach ( @{$sizes} ) {
      $_ = Thingiverse::SizedImage->new($_) if (ref($_) eq 'HASH' );;
	}
  }
  return $self;
};

sub _get_from_thingi_given_id {
  my ( $thing_id, $image_id ) = @_;
  my $request = sprintf $api_base, $thing_id, $image_id;
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__


{
  id: 880611
  name: "rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0.jpg"
  url: "https://api.thingiverse.com/things/316754/images/880611"
  sizes: [15]
  0:  {
    type: "thumb"
    size: "large"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_thumb_large.jpg"
  }-
  1:  {
    type: "thumb"
    size: "medium"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_thumb_medium.jpg"
  }-
  2:  {
    type: "thumb"
    size: "small"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_thumb_small.jpg"
  }-
  3:  {
    type: "thumb"
    size: "tiny"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_thumb_tiny.jpg"
  }-
  4:  {
    type: "preview"
    size: "featured"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_featured.jpg"
  }-
  5:  {
    type: "preview"
    size: "card"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_card.jpg"
  }-
  6:  {
    type: "preview"
    size: "large"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_large.jpg"
  }-
  7:  {
    type: "preview"
    size: "medium"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_medium.jpg"
  }-
  8:  {
    type: "preview"
    size: "small"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_small.jpg"
  }-
  9:  {
    type: "preview"
    size: "birdwing"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_birdwing.jpg"
  }-
  10:  {
    type: "preview"
    size: "tiny"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_tiny.jpg"
  }-
  11:  {
    type: "preview"
    size: "tinycard"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_preview_tinycard.jpg"
  }-
  12:  {
    type: "display"
    size: "large"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_display_large.jpg"
  }-
  13:  {
    type: "display"
    size: "medium"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_display_medium.jpg"
  }-
  14:  {
    type: "display"
    size: "small"
    url: "https://thingiverse-production.s3.amazonaws.com/renders/e4/61/5c/c6/82/rounded_rectangular_parallelepiped_20140501-27286-2xdd64-0_display_small.jpg"
  }
}
