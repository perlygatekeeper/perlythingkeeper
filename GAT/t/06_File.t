#!/usr/bin/env perl

use Test::Most tests => 11 + 8;
use Data::Dumper;

use GAT;
use Thingiverse::File;

my $id           = '556207';
my $image_id     = '875072';
# my $name         = 'rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0.stl';
my $name         = qr(rounded.rectangular.parallelepiped.*\.stl);
my $size         = '57251';
my $public_url   = 'http://www.thingiverse.com/download:'    . $id;
my $url          = $Thingiverse::api_uri_base . $GAT::File::api_base . $id;

my $file = Thingiverse::File->new( 'id' => $id );
# print Dumper($file);

    ok( defined $file,            'Thingiverse::File object is defined' ); 
    ok( $file->isa('Thingiverse::File'), 'can make an GAT::File object' ); 
can_ok( $file, qw( id ),                  );
can_ok( $file, qw( name ),                );
can_ok( $file, qw( size ),                );
can_ok( $file, qw( url ),                 );
can_ok( $file, qw( public_url ),          );
can_ok( $file, qw( download_url ),        );
can_ok( $file, qw( threejs_url ),         );
can_ok( $file, qw( thumbnail ),           );
can_ok( $file, qw( default_image ),       );

    is( $file->id,                     $id,                     'id             accessor' ); 
  like( $file->name,                   $name,                   'name           accessor' ); 
    is( $file->public_url,             $public_url,             'public_url     accessor' ); 
cmp_ok( $file->size,        "==",      $size,                   'size           accessor' ); 
    is( $file->url,                    $url,                    'url            accessor' ); 
    is( $file->download_url,           $url . '/download',      'download_url   accessor' ); 
  like( $file->threejs_url,            qr(.*),                  'threejs_url    accessor' ); 
    is( ref($file->default_image),     'HASH',                  'default_image  hashref?' ); 
    is( ${$file->default_image}{id},   $image_id,               'default_image  accessor' ); 

if ( 0 ) {
  print "nofile\n";
}

exit 0;
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
