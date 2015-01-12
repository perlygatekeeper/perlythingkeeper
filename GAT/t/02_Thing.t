#!/usr/bin/env perl 

use Test::Most tests => 37 + 34;
use Data::Dumper;

use GAT;
use GAT::Thing;

my $id         = '314355';
my $public_url = 'http://www.thingiverse.com/thing:'        . $id;
my $url        = $GAT::api_uri_base . $GAT::Thing::api_base . $id;
my $layout_url = $GAT::api_uri_base . '/layouts/' . $id;

my $thing = GAT::Thing->new( 'id' => $id );
# print Dumper($thing);

    ok( defined $thing,            'GAT::Thing object is defined' ); 
    ok( $thing->isa('GAT::Thing'), 'can make an GAT::Thing object' ); 
can_ok( $thing, qw( id ),                  );
can_ok( $thing, qw( name ),                );
can_ok( $thing, qw( instructions ),        );
can_ok( $thing, qw( instructions_html ),   );
can_ok( $thing, qw( description ),         );
can_ok( $thing, qw( description_html ),    );
can_ok( $thing, qw( url ),                 );
can_ok( $thing, qw( public_url ),          );
can_ok( $thing, qw( tags_url ),            );
can_ok( $thing, qw( likes_url ),           );
can_ok( $thing, qw( images_url ),          );
can_ok( $thing, qw( ancestors_url ),       );
can_ok( $thing, qw( categories_url ),      );
can_ok( $thing, qw( derivatives_url ),     );
can_ok( $thing, qw( layouts_url ),         );
can_ok( $thing, qw( files_url ),           );
can_ok( $thing, qw( thumbnail ),           );
can_ok( $thing, qw( is_wip ),              );
can_ok( $thing, qw( is_liked ),            );
can_ok( $thing, qw( is_private ),          );
can_ok( $thing, qw( in_library ),          );
can_ok( $thing, qw( is_collected ),        );
can_ok( $thing, qw( is_purchased ),        );
can_ok( $thing, qw( is_published ),        );
can_ok( $thing, qw( added ),               );
can_ok( $thing, qw( modified ),            );
can_ok( $thing, qw( license ),             );
can_ok( $thing, qw( like_count ),          );
can_ok( $thing, qw( file_count ),          );
can_ok( $thing, qw( layout_count ),        );
can_ok( $thing, qw( collect_count ),       );
can_ok( $thing, qw( print_history_count ), );
can_ok( $thing, qw( ancestors ),           );
can_ok( $thing, qw( derivatives ),         );
can_ok( $thing, qw( prints ),              );

    is( $thing->id,                  $id,                                    'id accessor' ); 
  like( $thing->name,                qr(Rounded Rectangular Parallelepiped), 'name accessor' ); 
  like( $thing->instructions,        qr(Using the following options),                                     'instructions accessor' ); 
  like( $thing->instructions_html,   qr(Using the following options),                                     'instructions_html accessor' ); 
  like( $thing->description,         qr(Customized version of http://www.thingiverse.com/thing:313179),   'description accessor' ); 
  like( $thing->description_html,    qr(Customized version of .*http://www.thingiverse.com/thing:313179), 'description_html accessor' ); 
  like( $thing->license,             qr(Creative Commons),                                                'license accessor' ); 
    is( $thing->public_url,          $public_url,                'public_url  accessor' ); 
    is( $thing->url,                 $url,                              'url  accessor' ); 
    is( $thing->images_url,          $url . '/images',           'images_url  accessor' ); 
    is( $thing->categories_url,      $url . '/categories',   'categories_url  accessor' ); 
    is( $thing->ancestors_url,       $url . '/ancestors',     'ancestors_url  accessor' ); 
    is( $thing->tags_url,            $url . '/tags',               'tags_url  accessor' ); 
    is( $thing->files_url,           $url . '/files',             'files_url  accessor' ); 
    is( $thing->derivatives_url,     $url . '/derivatives', 'derivatives_url  accessor' ); 
    is( $thing->likes_url,           $url . '/likes',             'likes_url  accessor' ); 
    is( $thing->layouts_url,         $layout_url,               'layouts_url  accessor' ); 
  like( $thing->is_wip,              qr(true|false),            'is_wip       accessor' ); 
  like( $thing->is_liked,            qr(true|false),            'is_liked     accessor' ); 
  like( $thing->is_private,          qr(true|false),            'is_private   accessor' ); 
  like( $thing->in_library,          qr(true|false),            'in_library   accessor' ); 
  like( $thing->is_collected,        qr(true|false),            'is_collected accessor' ); 
  like( $thing->is_purchased,        qr(true|false),            'is_purchased accessor' ); 
  like( $thing->is_published,        qr(true|false),            'is_published accessor' ); 
  like( $thing->added,               qr(^2014-04-29T\d\d:\d\d:\d\d\+00:00$), 'added accessor' );
  like( $thing->modified,            qr(^2014-04-29T\d\d:\d\d:\d\d\+00:00$), 'added accessor' );
  like( $thing->like_count,          qr(^\d+), 'like_count    accessor' );
  like( $thing->file_count,          qr(^\d+), 'file_count    accessor' );
  like( $thing->layout_count,        qr(^\d+), 'layout_count  accessor' );
  like( $thing->collect_count,       qr(^\d+), 'collect_count accessor' );
  like( $thing->print_history_count, qr(^\d+), 'print_history_count accessor' );

$thing = GAT::Thing->new( 'id' => '316754' );
SKIP: {
	skip "no prints for test thing", 1 unless defined($thing->prints);
    is( @{$thing->prints},           0,        'prints         an  ArraryRef' );
}
SKIP: {
	skip "no ancestors of test thing", 2 unless defined($thing->ancestors);
    is( @{$thing->ancestors},        1,        'ancestors  is  an  ArraryRef' );
    is( ${$thing->ancestors}[0]->id, '313179', 'ancestor   is the right onef' );
}
SKIP: {
	skip "no derivatives of test thing", 1 unless defined($thing->derivatives);
    is( @{$thing->derivatives},      0,        'derivatives    an  ArraryRef' );
}

if ( 0 ) {
  print "nothing\n";
}

exit 0;
__END__

special methods:
  publish
  like
  unlike
  package
  threadedcomments

Class methods or things.pm as well as thing.pm?
  newest
  featured
  popular

  search

{
  id: 314355
  name: "Rounded Rectangular Parallelepiped (all defaults)"
  thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/db/47/6b/0f/96/rounded_rectangular_parallelepiped_20140429-27229-1qiulcd-0_thumb_medium.jpg"
  url: "https://api.thingiverse.com/things/314355"
  public_url: "http://www.thingiverse.com/thing:314355"
  creator: {...}-
  added: "2014-04-29T04:06:30+00:00"
  modified: "2014-04-29T04:06:30+00:00"
  is_published: true
  is_wip: false
  is_featured: false
  like_count: 0
  is_liked: false
  collect_count: 0
  is_collected: false
  default_image: {...}-
  description: "Customized version of http://www.thingiverse.com/thing:313179 Created with Customizer! http://www.thingiverse.com/apps/customizer/run?thing_id=313179 "
  instructions: "Using the following options: customizer_z = 2 customizer_y = 10 customizer_x = 5 customizer_facets = 16 customizer_rounding_radius = 1 "
  description_html: "<p>Customized version of <a href="http://www.thingiverse.com/thing:313179">http://www.thingiverse.com/thing:313179</a></p> <p>Created with Customizer! <a href="http://www.thingiverse.com/apps/customizer/run?thing_id=313179">http://www.thingiverse.com/apps/customizer/run?thing_id=313179</a></p>"
  instructions_html: "<p>Using the following options:</p> <p>customizer_z = 2 customizer_y = 10 customizer_x = 5 customizer_facets = 16 customizer_rounding_radius = 1</p>"
  license: "Creative Commons - Attribution"
  files_url: "https://api.thingiverse.com/things/314355/files"
  images_url: "https://api.thingiverse.com/things/314355/images"
  likes_url: "https://api.thingiverse.com/things/314355/likes"
  ancestors_url: "https://api.thingiverse.com/things/314355/ancestors"
  derivatives_url: "https://api.thingiverse.com/things/314355/derivatives"
  tags_url: "https://api.thingiverse.com/things/314355/tags"
  categories_url: "https://api.thingiverse.com/things/314355/categories"
  file_count: 1
  layout_count: 0
  layouts_url: "https://api.thingiverse.com/layouts/314355"
  is_private: false
  is_purchased: false
  in_library: true
  print_history_count: 0
  app_id: 22
}



{
   "id" : 15528,
   "name" : "Moon Rover",
   "app_id" : null,

   "instructions" : "Print the parts list (use multiply on the wheels and wheelpegs).  For the tracks, turn off fill entirely so it just prints the perimeter.  The rover body wants to warp (the slices are strain reliefs, but they only help so much).  Mine worked fine even though the body was warped, but this might be a good application for PLA.  On the other hand, I'm not sure how well the tracks will function without the pliability of ABS.  \r\n\r\nThe OpenSCAD file is parameterized so you can play around with different track dimensions.  Ten points to anyone who posts a derivative with a cooler-looking rover body.",

   "instructions_html" : "<p>Print the parts list (use multiply on the wheels and wheelpegs).  For the tracks, turn off fill entirely so it just prints the perimeter.  The rover body wants to warp (the slices are strain reliefs, but they only help so much).  Mine worked fine even though the body was warped, but this might be a good application for PLA.  On the other hand, I'm not sure how well the tracks will function without the pliability of ABS.  </p>\n<p>The OpenSCAD file is parameterized so you can play around with different track dimensions.  Ten points to anyone who posts a derivative with a cooler-looking rover body.</p>",

   "description" : "This moon rover is pretty simple; the real point is the treads.  The idea of turning my Stretchy Bracelet into tank tracks is thanks to BenRockhold.  Turns out it works really well: if you push this around on a slightly grippy surface like carpet, the tracks roll easily.\r\n\r\nIn fact, the track keys into the wheels so well, this could probably be used as a timing belt or chain.  ",
   "modified" : "2012-01-06T11:13:34+00:00",

   "description_html" : "<p>This moon rover is pretty simple; the real point is the treads.  The idea of turning my Stretchy Bracelet into tank tracks is thanks to BenRockhold.  Turns out it works really well: if you push this around on a slightly grippy surface like carpet, the tracks roll easily.</p>\n<p>In fact, the track keys into the wheels so well, this could probably be used as a timing belt or chain.  </p>",

   "creator" : {
      "thumbnail" : "https://thingiverse-production.s3.amazonaws.com/renders/12/36/7c/69/8a/B1_display_large_thumb_medium.jpg",
      "url" : "https://api.thingiverse.com/users/emmett",
      "name" : "emmett",
      "id" : 8844,
      "public_url" : "http://www.thingiverse.com/emmett",
      "last_name" : "Lalish",
      "first_name" : "Emmett"
   },

   "like_count" : 254,
   "file_count" : 5,
   "layout_count" : 0,
   "collect_count" : 333,
   "print_history_count" : 0,

   "public_url"      : "http://www.thingiverse.com/thing:15528",
   "url"             : "https://api.thingiverse.com/things/15528",
   "images_url"      : "https://api.thingiverse.com/things/15528/images",
   "categories_url"  : "https://api.thingiverse.com/things/15528/categories",
   "ancestors_url"   : "https://api.thingiverse.com/things/15528/ancestors",
   "tags_url"        : "https://api.thingiverse.com/things/15528/tags",
   "derivatives_url" : "https://api.thingiverse.com/things/15528/derivatives",
   "likes_url"       : "https://api.thingiverse.com/things/15528/likes",
   "layouts_url"     : "https://api.thingiverse.com/layouts/15528"
   "files_url"       : "https://api.thingiverse.com/things/15528/files",
   "thumbnail"       : "https://thingiverse-production.s3.amazonaws.com/renders/46/f2/c8/23/8a/rover1_display_large_thumb_medium.jpg",

   "added" : "2012-01-06T11:13:34+00:00",
   "license" : "Creative Commons - Attribution - Share Alike",

   "is_wip" : false,
   "is_liked" : false,
   "is_private" : false,
   "in_library" : false,
   "is_featured" : false,
   "is_collected" : false,
   "is_purchased" : false,
   "is_published" : true,

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
}
