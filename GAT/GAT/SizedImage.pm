package GAT::SizedImage;
use Moose;
use Carp;
use JSON;
use GAT::Types;

has url   => ( isa => 'Str',                  is => 'ro', required => 0, );
has type  => ( isa => 'ThingiverseImageType', is => 'ro', required => 0, );
has size  => ( isa => 'ThingiverseImageSize', is => 'ro', required => 0, );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__


from images attribute of GAT::Image
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
