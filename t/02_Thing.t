#!/usr/bin/env perl 

use Test::Most tests => 92;
use Data::Dumper;

BEGIN {
    use_ok('Thingiverse');
    use_ok('Thingiverse::Thing');
}

my $id               = '314355';
my $creator_id       = '16273';
my $default_image_id = '875072';
my $public_url       = 'http://www.thingiverse.com/thing:'        . $id;
my $url              = $Thingiverse::api_uri_base . Thingiverse::Thing->api_base() . $id;
my $layout_url       = $Thingiverse::api_uri_base . '/layouts/' . $id;

my $thing = Thingiverse::Thing->new( 'id' => $id, thingiverse => Thingiverse->new() );
# print Dumper($thing);

    ok( defined $thing,            'Thingiverse::Thing object is defined' ); 
    ok( $thing->isa('Thingiverse::Thing'), 'can make an Thingiverse::Thing object' ); 
can_ok( $thing, qw( id ),                  );
can_ok( $thing, qw( name ),                );
can_ok( $thing, qw( creator ),             );
can_ok( $thing, qw( default_image ),       );
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
can_ok( $thing, qw( images ),              );
can_ok( $thing, qw( tags ),                );

    is( $thing->id,                  $id,                                    'id accessor' ); 
    ok( $thing->creator->isa('Thingiverse::User'),                           'is the creator a Thingiverse::User object' ); 
    is( $thing->creator->id,         $creator_id,                            'creator_id correct' ); 

    ok( $thing->default_image->isa('Thingiverse::Image'),                    'is the default_image a Thingiverse::Image object' ); 
    is( $thing->default_image->id,   $default_image_id,                      "default_images's id correct" ); 

  like( $thing->name,                qr(Rounded Rectangular Parallelepiped),                              'name                accessor' ); 
  like( $thing->instructions,        qr(Using the following options),                                     'instructions        accessor' ); 
  like( $thing->instructions_html,   qr(Using the following options),                                     'instructions_html   accessor' ); 
  like( $thing->description,         qr(Customized version of http://www.thingiverse.com/thing:313179),   'description         accessor' ); 
  like( $thing->description_html,    qr(Customized version of .*http://www.thingiverse.com/thing:313179), 'description_html    accessor' ); 
  like( $thing->license,             qr(Creative Commons),                                                'license             accessor' ); 
    is( $thing->public_url,          $public_url,                                                         'public_url          accessor' ); 
    is( $thing->url,                 $url,                                                                'url                 accessor' ); 
    is( $thing->images_url,          $url . '/images',                                                    'images_url          accessor' ); 
    is( $thing->categories_url,      $url . '/categories',                                                'categories_url      accessor' ); 
    is( $thing->ancestors_url,       $url . '/ancestors',                                                 'ancestors_url       accessor' ); 
    is( $thing->tags_url,            $url . '/tags',                                                      'tags_url            accessor' ); 
    is( $thing->files_url,           $url . '/files',                                                     'files_url           accessor' ); 
    is( $thing->derivatives_url,     $url . '/derivatives',                                               'derivatives_url     accessor' ); 
    is( $thing->likes_url,           $url . '/likes',                                                     'likes_url           accessor' ); 
    is( $thing->layouts_url,         $layout_url,                                                         'layouts_url         accessor' ); 
  like( $thing->is_wip,              qr(true|false),                                                      'is_wip              accessor' ); 
  like( $thing->is_liked,            qr(true|false),                                                      'is_liked            accessor' ); 
  like( $thing->is_private,          qr(true|false),                                                      'is_private          accessor' ); 
  like( $thing->in_library,          qr(true|false),                                                      'in_library          accessor' ); 
  like( $thing->is_collected,        qr(true|false),                                                      'is_collected        accessor' ); 
  like( $thing->is_purchased,        qr(true|false),                                                      'is_purchased        accessor' ); 
  like( $thing->is_published,        qr(true|false),                                                      'is_published        accessor' ); 
  like( $thing->added,               qr(^2014-04-29T\d\d:\d\d:\d\d\+00:00$),                              'added               accessor' );
  like( $thing->modified,            qr(^2014-04-29T\d\d:\d\d:\d\d\+00:00$),                              'modified            accessor' );
  like( $thing->like_count,          qr(^\d+),                                                            'like_count          accessor' );
  like( $thing->file_count,          qr(^\d+),                                                            'file_count          accessor' );
  like( $thing->layout_count,        qr(^\d+),                                                            'layout_count        accessor' );
  like( $thing->collect_count,       qr(^\d+),                                                            'collect_count       accessor' );
  like( $thing->print_history_count, qr(^\d+),                                                            'print_history_count accessor' );

$thing = Thingiverse::Thing->new( 'id' => '316754', thingiverse => Thingiverse->new() );
SKIP: {
    skip "no prints for test thing", 1 unless defined($thing->prints) and ref($thing->prints) eq 'ARRAY';
    is( @{$thing->prints},           0,        'prints         an  ArrayRef' );
}

## print "==\n";
$thing = Thingiverse::Thing->new( 'id' => '313179', thingiverse => Thingiverse->new() );
SKIP: {
    skip "no ancestors of test thing", 2 unless defined($thing->ancestors) and defined($thing->ancestors->things);
    print "thing->ancestors is (" . $thing->ancestors . ")\n" if ($Thingiverse::verbose);
    is( @{$thing->ancestors->things},         1,       'ancestors list is an ArrayRef' );
    is( ${$thing->ancestors->things}[0]->id, '275033', 'first ancestor is the right one' );
}
## print "**\n";
SKIP: {
    skip "no derivatives of test thing", 1 unless defined($thing->derivatives) and defined($thing->derivatives->things);
    is( @{$thing->derivatives->things},      2,        'derivatives list is an ArrayRef' );
}
# print "==\n";

$thing = Thingiverse::Thing->new( 'id' => '209078', thingiverse => Thingiverse->new() );
SKIP: {
    my $images = $thing->images;
    is( ref($images), 'Thingiverse::Image::List',  'images is         a    Thingiverse::Image::List' );
    can_ok( $images, qw( count_images ), );
    is( $images->count_images, 2,                  'images contains        2 images' );;
    can_ok( $images, qw( get_images ), );
    my $first_image = eval { $images->get_images(0) // {} };
    isa_ok( $first_image, 'Thingiverse::Image', 'first image is    a     Thingiverse::Image' );
}

SKIP: {
    my $tags = $thing->tags;
    skip "no tags for test thing", 1 unless defined($tags);
    is( ref($tags), 'Thingiverse::Tag::List',  'tags is a Thingiverse::Tag::List' );
can_ok( $tags, qw( count_tags ), );
    is( $tags->count_tags, 6,                   'tags contains 6 tags' );
can_ok( $tags, qw( get_tags ), );
    my $first_tag = $tags->get_tags(0);
    ok( $first_tag->isa('Thingiverse::Tag'),   'first tag is a Thingiverse::Tag' );
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

