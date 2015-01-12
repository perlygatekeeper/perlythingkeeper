package GAT::File;
use Moose;
use Carp;
use JSON;
use GAT::Types;

extends('GAT');
our $api_base = "/files/";

has id             => ( isa => 'Str',       is => 'ro', required => 1, );
has name           => ( isa => 'Str',       is => 'ro', required => 0, );
has size           => ( isa => 'Size',      is => 'ro', required => 0, );
has url            => ( isa => 'Str',       is => 'ro', required => 0, );
has public_url     => ( isa => 'Str',       is => 'ro', required => 0, );
has download_url   => ( isa => 'Str',       is => 'ro', required => 0, );
has threejs_url    => ( isa => 'Str',       is => 'ro', required => 0, );
has thumbnail      => ( isa => 'Str',       is => 'ro', required => 0, );
has date           => ( isa => 'Str',       is => 'ro', required => 0, );
has formated_size  => ( isa => 'Str',       is => 'ro', required => 0, );
has meta_data      => ( isa => 'ArrayRef',  is => 'ro', required => 0, );
has default_image  => ( isa => 'HashRef',   is => 'ro', required => 0, );
has _original_json => ( isa => 'Str',       is => 'ro', required => 0, );

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
  $json = _get_from_thingi_given_id($id);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_from_thingi_given_id {
  my $id = shift;
  my $request = $api_base . $id;
  my $rest_client = GAT::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

{
  id: 556207
  name: "rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0.stl"
  size: 57251
  url: "https://api.thingiverse.com/files/556207"
  public_url: "http://www.thingiverse.com/download:556207"
  download_url: "https://api.thingiverse.com/files/556207/download"
  threejs_url: "https://thingiverse-production.s3.amazonaws.com/threejs_json/d7/6b/04/3d/8a/b7c34426rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0.js"
  thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_thumb_medium.jpg"
  date: "2014-04-29 04:06:30"
  formatted_size: "55 kb"
  meta_data: [0]
  default_image: {
    id: 875072
    url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0.jpg"
    name: "rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0.jpg"
    sizes: [15]
    0:  {
      type: "thumb"
      size: "large"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_thumb_large.jpg"
    }-
    1:  {
      type: "thumb"
      size: "medium"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_thumb_medium.jpg"
    }-
    2:  {
      type: "thumb"
      size: "small"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_thumb_small.jpg"
    }-
    3:  {
      type: "thumb"
      size: "tiny"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_thumb_tiny.jpg"
    }-
    4:  {
      type: "preview"
      size: "featured"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_featured.jpg"
    }-
    5:  {
      type: "preview"
      size: "card"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_card.jpg"
    }-
    6:  {
      type: "preview"
      size: "large"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_large.jpg"
    }-
    7:  {
      type: "preview"
      size: "medium"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_medium.jpg"
    }-
    8:  {
      type: "preview"
      size: "small"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_small.jpg"
    }-
    9:  {
      type: "preview"
      size: "birdwing"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_birdwing.jpg"
    }-
    10:  {
      type: "preview"
      size: "tiny"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_tiny.jpg"
    }-
    11:  {
      type: "preview"
      size: "tinycard"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_preview_tinycard.jpg"
    }-
    12:  {
      type: "display"
      size: "large"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_display_large.jpg"
    }-
    13:  {
      type: "display"
      size: "medium"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_display_medium.jpg"
    }-
    14:  {
      type: "display"
      size: "small"
      url: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_display_small.jpg"
    }-
    added: "2014-04-29T04:10:37+00:00"
  }
}
