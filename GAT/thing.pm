package thing;
use Moose;
use Carp;

has id           => ( isa => 'str',          is => 'ro', required => 1, );
has name         => ( isa => 'Str',          is => 'ro', required => 0, );
has is_wip       => ( isa => 'Str',          is => 'ro', required => 0, );
has instructions => ( isa => 'Str',          is => 'ro', required => 0, );
has description  => ( isa => 'Str',          is => 'ro', required => 0, );
has license      => ( isa => 'str',          is => 'ro', required => 0, );
has prints       => ( isa => 'Str',          is => 'ro', required => 0, );
has images       => ( isa => 'Array[image]', is => 'ro', required => 0, );
has files        => ( isa => 'Array[file]',  is => 'ro', required => 0, );
has ancestors    => ( isa => 'Array[file]',  is => 'ro', required => 0, );
has derivatives  => ( isa => 'Array[file]',  is => 'ro', required => 0, );
has tags         => ( isa => 'Array[file]',  is => 'ro', required => 0, );
has categories   => ( isa => 'Array[file]',  is => 'ro', required => 0, );


no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
client_id( q(c587f0f2ee04adbe719b) );
access_token( q(b053a0798c50a84fbb80e66e51bba9c4) );

spwcial methods:
publish
like
unlike
package
threadedcomments

newest
featured
popular

search

{
   "is_private" : false,
   "instructions" : "Print the parts list (use multiply on the wheels and wheelpegs).  For the tracks, turn off fill entirely so it just prints the perimeter.  The rover body wants to warp (the slices are strain reliefs, but they only help so much).  Mine worked fine even though the body was warped, but this might be a good application for PLA.  On the other hand, I'm not sure how well the tracks will function without the pliability of ABS.  \r\n\r\nThe OpenSCAD file is parameterized so you can play around with different track dimensions.  Ten points to anyone who posts a derivative with a cooler-looking rover body.",
   "creator" : {
      "thumbnail" : "https://thingiverse-production.s3.amazonaws.com/renders/12/36/7c/69/8a/B1_display_large_thumb_medium.jpg",
      "url" : "https://api.thingiverse.com/users/emmett",
      "name" : "emmett",
      "id" : 8844,
      "public_url" : "http://www.thingiverse.com/emmett",
      "last_name" : "Lalish",
      "first_name" : "Emmett"
   },
   "print_history_count" : 0,
   "images_url" : "https://api.thingiverse.com/things/15528/images",
   "categories_url" : "https://api.thingiverse.com/things/15528/categories",
   "instructions_html" : "<p>Print the parts list (use multiply on the wheels and wheelpegs).  For the tracks, turn off fill entirely so it just prints the perimeter.  The rover body wants to warp (the slices are strain reliefs, but they only help so much).  Mine worked fine even though the body was warped, but this might be a good application for PLA.  On the other hand, I'm not sure how well the tracks will function without the pliability of ABS.  </p>\n<p>The OpenSCAD file is parameterized so you can play around with different track dimensions.  Ten points to anyone who posts a derivative with a cooler-looking rover body.</p>",
   "url" : "https://api.thingiverse.com/things/15528",
   "ancestors_url" : "https://api.thingiverse.com/things/15528/ancestors",
   "is_featured" : false,
   "id" : 15528,
   "tags_url" : "https://api.thingiverse.com/things/15528/tags",
   "is_liked" : false,
   "layout_count" : 0,
   "like_count" : 254,
   "name" : "Moon Rover",
   "description" : "This moon rover is pretty simple; the real point is the treads.  The idea of turning my Stretchy Bracelet into tank tracks is thanks to BenRockhold.  Turns out it works really well: if you push this around on a slightly grippy surface like carpet, the tracks roll easily.\r\n\r\nIn fact, the track keys into the wheels so well, this could probably be used as a timing belt or chain.  ",
   "modified" : "2012-01-06T11:13:34+00:00",
   "files_url" : "https://api.thingiverse.com/things/15528/files",
   "is_collected" : false,
   "is_purchased" : false,
   "default_image" : {
      "added" : "2012-01-06T10:52:31+00:00",
      "name" : "",
      "url" : "",
      "id" : 97363,
      "sizes" : [
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_thumb_large.jpg",
            "type" : "thumb",
            "size" : "large"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_thumb_medium.jpg",
            "type" : "thumb",
            "size" : "medium"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_thumb_small.jpg",
            "type" : "thumb",
            "size" : "small"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_thumb_tiny.jpg",
            "type" : "thumb",
            "size" : "tiny"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_featured.jpg",
            "type" : "preview",
            "size" : "featured"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_card.jpg",
            "type" : "preview",
            "size" : "card"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_large.jpg",
            "type" : "preview",
            "size" : "large"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_medium.jpg",
            "type" : "preview",
            "size" : "medium"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_small.jpg",
            "type" : "preview",
            "size" : "small"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_birdwing.jpg",
            "type" : "preview",
            "size" : "birdwing"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_tiny.jpg",
            "type" : "preview",
            "size" : "tiny"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_preview_tinycard.jpg",
            "type" : "preview",
            "size" : "tinycard"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_display_large.jpg",
            "type" : "display",
            "size" : "large"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_display_medium.jpg",
            "type" : "display",
            "size" : "medium"
         },
         {
            "url" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_display_small.jpg",
            "type" : "display",
            "size" : "small"
         }
      ]
   },
   "description_html" : "<p>This moon rover is pretty simple; the real point is the treads.  The idea of turning my Stretchy Bracelet into tank tracks is thanks to BenRockhold.  Turns out it works really well: if you push this around on a slightly grippy surface like carpet, the tracks roll easily.</p>\n<p>In fact, the track keys into the wheels so well, this could probably be used as a timing belt or chain.  </p>",
   "file_count" : 5,
   "app_id" : null,
   "added" : "2012-01-06T11:13:34+00:00",
   "public_url" : "http://www.thingiverse.com/thing:15528",
   "derivatives_url" : "https://api.thingiverse.com/things/15528/derivatives",
   "thumbnail" : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_thumb_medium.jpg",
   "is_wip" : false,
   "likes_url" : "https://api.thingiverse.com/things/15528/likes",
   "license" : "Creative Commons - Attribution - Share Alike",
   "in_library" : false,
   "is_published" : true,
   "collect_count" : 333,
   "layouts_url" : "https://api.thingiverse.com/layouts/15528"
}
