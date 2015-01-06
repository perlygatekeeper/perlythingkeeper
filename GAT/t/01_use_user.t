#!/usr/bin/env perl

use Test::Most tests => 35;
use Data::Dumper;

use GAT::user;

my $user = GAT::user->new( 'name' => 'perlygatekeeper' );

ok( defined $user, 'GAT::user object is defined' ); 
ok( $user->isa('GAT::user'), 'can make an GAT::user object' ); 
can_ok( $user, qw( id ),              );
can_ok( $user, qw( name ),            );
can_ok( $user, qw( first_name ),      );
can_ok( $user, qw( last_name ),       );
can_ok( $user, qw( full_name ),       );
can_ok( $user, qw( url ),             );
can_ok( $user, qw( public_url ),      );
can_ok( $user, qw( thumbnail ),       );
can_ok( $user, qw( bio ),             );
can_ok( $user, qw( location ),        );
can_ok( $user, qw( registered ),      );
can_ok( $user, qw( last_active ),     );
can_ok( $user, qw( cover_image ),     );
can_ok( $user, qw( things_url ),      );
can_ok( $user, qw( copies_url ),      );
can_ok( $user, qw( likes_url ),       );
can_ok( $user, qw( default_license ), );
can_ok( $user, qw( email ),           );
can_ok( $user, qw( is_following ),    );
is( $user->id, '16273', 'id accessor' ); 
is( $user->name, 'perlygatekeeper', 'name accessor' ); 
is( $user->email, 'perlygatekeeper@gmail.com', 'email accessor' ); 
is( $user->first_name, 'Steve', 'first_name accessor' ); 
is( $user->last_name,  'Parker', 'last_name accessor' ); 
is( $user->full_name,  'Steve Parker', 'full_name accessor' ); 
is( $user->location,  'Columbus, Ohio', 'location accessor' ); 
like( $user->bio, qr(Ohio State University), 'bio accessor' ); 
is( $user->public_url, 'http://www.thingiverse.com/perlygatekeeper',         'public_url accessor' ); 
is( $user->url,        'https://api.thingiverse.com/users/perlygatekeeper',         'url accessor' ); 
is( $user->things_url, 'https://api.thingiverse.com/users/perlygatekeeper/things', 'things_url accessor' ); 
is( $user->copies_url, 'https://api.thingiverse.com/users/perlygatekeeper/copies', 'copies_url accessor' ); 
is( $user->likes_url,  'https://api.thingiverse.com/users/perlygatekeeper/likes',   'likes_url accessor' ); 
is( $user->default_license, 'cc', 'default_license accessor' );


print Dumper($user);

exit 0;
__END__
use Moose;
use Carp;
use JSON;

extends('GAT');

our $api_base = "/users/";

# has    _json_from_api => ( isa => 'HashRef[Str]', is => 'ro', required => 0, builder => '_get_from_thingi', );
# has   _hash_from_json => ( isa => 'HashRef[Str]', is => 'ro', required => 0, builder => '_json_to_hash', );
has                id => ( isa => 'Str',          is => 'ro', required => 0, );
has    _original_json => ( isa => 'Str',          is => 'ro', required => 0, );
has              name => ( isa => 'Str',          is => 'ro', required => 1, );
has        first_name => ( isa => 'Str',          is => 'ro', required => 0, );
has         last_name => ( isa => 'Str',          is => 'ro', required => 0, );
has         full_name => ( isa => 'Str',          is => 'ro', required => 0, );
has               url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has        public_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has         thumbnail => ( isa => 'Str',          is => 'ro', required => 0, );
has               bio => ( isa => 'Str',          is => 'ro', required => 0, );
has          location => ( isa => 'Str',          is => 'ro', required => 0, );
has        registered => ( isa => 'Str',          is => 'ro', required => 0, );
# has        registered => ( isa => 'Date::Time',   is => 'ro', required => 0, );
has       last_active => ( isa => 'Str',          is => 'ro', required => 0, );
# has       last_active => ( isa => 'Date::Time',   is => 'ro', required => 0, );
has       cover_image => ( isa => 'Any',          is => 'ro', required => 0, );
has        things_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has        copies_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has         likes_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has   default_license => ( isa => 'Str',          is => 'ro', required => 0, );
has             email => ( isa => 'Str',          is => 'ro', required => 0, );
has      is_following => ( isa => 'Boolean',      is => 'ro', required => 0, );
# has           likes => ( isa => 'ArrayRef[thing]',      is => 'ro', required => 0, );
# has          things => ( isa => 'ArrayRef[thing]',      is => 'ro', required => 0, );
# has     collections => ( isa => 'ArrayRef[collection]', is => 'ro', required => 0, );
# has       downloads => ( isa => 'ArrayRef[thing]',      is => 'ro', required => 0, );
# has     avatarimage => ( isa => 'Str',                  is => 'ro', required => 0, );
# has      coverimage => ( isa => 'Str',                  is => 'ro', required => 0, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $name;
  my $json;
  my $hash;
# print "yeah! I'm being run!\n";
# print "orig is (" . $orig . ")\n";
# print "class is (" . $class . ")\n";
# print "rest is (" . join(', ',@_) . ")\n";
  if ( @_ == 1 && !ref $_[0] ) {
#   print "given scalar name\n";
    # return $class->$orig( name => $_[0] );
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}->{'name'} ) { # passed a hashref to a hash containing key 'name'
#   print "given hashref with name\n";
    $name = ${$_[0]}->{'name'};
  } elsif ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
#   print "given 'name' then name\n";
    $name = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_from_thingi_given_name($name);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_from_thingi {
  my $self = shift;
  my $request = $api_base. ( $self->name || 'me' );
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_from_thingi_given_name {
  my $name = shift;
  my $request = $api_base . $name;
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
		id: 16273
		name: "perlygatekeeper"
		first_name: "Steve"
		last_name: "Parker"
		full_name: "Steve Parker"
		url: "https://api.thingiverse.com/users/perlygatekeeper"
		public_url: "http://www.thingiverse.com/perlygatekeeper"
		thumbnail: "https://www.thingiverse.com/img/default/avatar/avatar_default_thumb_medium.jpg"
		bio: ""
		location: ""
		registered: "2011-11-20T18:52:00+00:00"
		last_active: "2015-01-03T01:39:45+00:00"
		cover_image: null
		things_url: "https://api.thingiverse.com/users/perlygatekeeper/things"
		copies_url: "https://api.thingiverse.com/users/perlygatekeeper/copies"
		likes_url: "https://api.thingiverse.com/users/perlygatekeeper/likes"
		default_license: "cc"
		email: "perlygatekeeper@gmail.com"
}
1..23
ok 1 - GAT::user object is defined
ok 2 - can make an GAT::user object
ok 3 - GAT::user->can('id')
ok 4 - GAT::user->can('name')
ok 5 - GAT::user->can('first_name')
ok 6 - GAT::user->can('last_name')
ok 7 - GAT::user->can('full_name')
ok 8 - GAT::user->can('url')
ok 9 - GAT::user->can('public_url')
ok 10 - GAT::user->can('thumbnail')
ok 11 - GAT::user->can('bio')
ok 12 - GAT::user->can('location')
ok 13 - GAT::user->can('registered')
ok 14 - GAT::user->can('last_active')
ok 15 - GAT::user->can('cover_image')
ok 16 - GAT::user->can('things_url')
ok 17 - GAT::user->can('copies_url')
ok 18 - GAT::user->can('likes_url')
ok 19 - GAT::user->can('default_license')
ok 20 - GAT::user->can('email')
ok 21 - GAT::user->can('is_following')
ok 22 - id accessor
ok 23 - name accessor
$VAR1 = bless( {
                 'id' => 16273,
                 'name' => 'perlygatekeeper',
                 'email' => 'perlygatekeeper@gmail.com',
                 'location' => '',
                 'bio' => '',

                 'default_license' => 'cc',

                 'first_name' => 'Steve',
                 'last_name' => 'Parker',
                 'full_name' => 'Steve Parker',

                 'url'        => 'https://api.thingiverse.com/users/perlygatekeeper',
                 'public_url' => 'http://www.thingiverse.com/perlygatekeeper',
                 'things_url' => 'https://api.thingiverse.com/users/perlygatekeeper/things',
                 'copies_url' => 'https://api.thingiverse.com/users/perlygatekeeper/copies',
                 'likes_url'  => 'https://api.thingiverse.com/users/perlygatekeeper/likes',

                 'registered ' => '2011-11-20T18:52:00+00:00',
                 'last_active' => '2015-01-06T05:21:39+00:00',

                 'thumbnail' => 'https://thingiverse-production.s3.amazonaws.com/renders/d3/5f/cb/0e/10/1524947_10202021360430593_1566936778_n_thumb_medium.jpg',
                 'cover_image' => {
                                    'added' => '2015-01-06T05:24:43+00:00',
                                    'name' => 'Screen_Shot_2014-04-30_at_11.37.53_PM.png',
                                    'url' => 'https://thingiverse-production.s3.amazonaws.com/assets/59/87/04/f1/da/Screen_Shot_2014-04-30_at_11.37.53_PM.png',
                                    'id' => 1632465,
                                    'sizes' => [
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_large.jpg',
                                                   'type' => 'thumb',
                                                   'size' => 'large'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_medium.jpg',
                                                   'type' => 'thumb',
                                                   'size' => 'medium'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_small.jpg',
                                                   'type' => 'thumb',
                                                   'size' => 'small'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_tiny.jpg',
                                                   'type' => 'thumb',
                                                   'size' => 'tiny'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_featured.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'featured'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_card.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'card'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_large.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'large'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_medium.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'medium'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_small.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'small'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_birdwing.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'birdwing'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_tiny.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'tiny'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_tinycard.jpg',
                                                   'type' => 'preview',
                                                   'size' => 'tinycard'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_display_large.jpg',
                                                   'type' => 'display',
                                                   'size' => 'large'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_display_medium.jpg',
                                                   'type' => 'display',
                                                   'size' => 'medium'
                                                 },
                                                 {
                                                   'url' => 'https://thingiverse-production.s3.amazonaws.com/renders/df/6b/8a/18/2d/Screen_Shot_2014-04-30_at_11.37.53_PM_display_small.jpg',
                                                   'type' => 'display',
                                                   'size' => 'small'
                                                 }
                                               ]
                                  },

                 '_original_json' => '{"id":16273,"name":"perlygatekeeper","first_name":"Steve","last_name":"Parker","full_name":"Steve Parker","url":"https:\\/\\/api.thingiverse.com\\/users\\/perlygatekeeper","public_url":"http:\\/\\/www.thingiverse.com\\/perlygatekeeper","thumbnail":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/d3\\/5f\\/cb\\/0e\\/10\\/1524947_10202021360430593_1566936778_n_thumb_medium.jpg","bio":"","location":"","registered":"2011-11-20T18:52:00+00:00","last_active":"2015-01-06T05:21:39+00:00","cover_image":{"id":1632465,"url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/assets\\/59\\/87\\/04\\/f1\\/da\\/Screen_Shot_2014-04-30_at_11.37.53_PM.png","name":"Screen_Shot_2014-04-30_at_11.37.53_PM.png","sizes":[{"type":"thumb","size":"large","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_large.jpg"},{"type":"thumb","size":"medium","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_medium.jpg"},{"type":"thumb","size":"small","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_small.jpg"},{"type":"thumb","size":"tiny","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_thumb_tiny.jpg"},{"type":"preview","size":"featured","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_featured.jpg"},{"type":"preview","size":"card","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_card.jpg"},{"type":"preview","size":"large","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_large.jpg"},{"type":"preview","size":"medium","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_medium.jpg"},{"type":"preview","size":"small","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_small.jpg"},{"type":"preview","size":"birdwing","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_birdwing.jpg"},{"type":"preview","size":"tiny","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_tiny.jpg"},{"type":"preview","size":"tinycard","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_preview_tinycard.jpg"},{"type":"display","size":"large","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_display_large.jpg"},{"type":"display","size":"medium","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_display_medium.jpg"},{"type":"display","size":"small","url":"https:\\/\\/thingiverse-production.s3.amazonaws.com\\/renders\\/df\\/6b\\/8a\\/18\\/2d\\/Screen_Shot_2014-04-30_at_11.37.53_PM_display_small.jpg"}],"added":"2015-01-06T05:24:43+00:00"},"things_url":"https:\\/\\/api.thingiverse.com\\/users\\/perlygatekeeper\\/things","copies_url":"https:\\/\\/api.thingiverse.com\\/users\\/perlygatekeeper\\/copies","likes_url":"https:\\/\\/api.thingiverse.com\\/users\\/perlygatekeeper\\/likes","default_license":"cc","email":"perlygatekeeper@gmail.com"}',

               }, 'GAT::user' );
