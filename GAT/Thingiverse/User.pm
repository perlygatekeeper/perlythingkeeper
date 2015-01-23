package Thingiverse::User;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;
use Data::Dumper;

extends('Thingiverse');
our $api_base = "/users/";

has id              => ( isa => 'ID',                        is => 'ro', required => 0, );
has _original_json  => ( isa => 'Str',                       is => 'ro', required => 0, );
has name            => ( isa => 'Str',                       is => 'ro', required => 1, );
has first_name      => ( isa => 'Str',                       is => 'ro', required => 0, );
has last_name       => ( isa => 'Str',                       is => 'ro', required => 0, );
has full_name       => ( isa => 'Str',                       is => 'ro', required => 0, );
has url             => ( isa => 'Str',                       is => 'ro', required => 0, ); # change to type URL once it's made
has public_url      => ( isa => 'Str',                       is => 'ro', required => 0, ); # change to type URL once it's made
has thumbnail       => ( isa => 'Str',                       is => 'ro', required => 0, );
has bio             => ( isa => 'Str',                       is => 'ro', required => 0, );
has location        => ( isa => 'Str',                       is => 'ro', required => 0, );
has registered      => ( isa => 'ThingiverseDateTime',       is => 'ro', required => 0, coerce  => 1 );
has last_active     => ( isa => 'ThingiverseDateTime',       is => 'ro', required => 0, coerce  => 1 );
has cover_image     => ( isa => 'Any',                       is => 'ro', required => 0, );
has things_url      => ( isa => 'Str',                       is => 'ro', required => 0, ); # change to type URL once it's made
has copies_url      => ( isa => 'Str',                       is => 'ro', required => 0, ); # change to type URL once it's made
has likes_url       => ( isa => 'Str',                       is => 'ro', required => 0, ); # change to type URL once it's made
has default_license => ( isa => 'Str',                       is => 'ro', required => 0, );
has email           => ( isa => 'Str',                       is => 'ro', required => 0, );
has is_following    => ( isa => 'Boolean',                   is => 'ro', required => 0, );
has things          => ( isa => 'ArrayRef[HashRef]',         is => 'ro', required => 0, builder => '_get_things_owned_by_user' );
# has likes           => ( isa => 'ArrayRef[Thingiverse::Thing]',      is => 'ro', required => 0, builder  => '_get_things_liked_by_user' );
# has copies          => ( isa => 'ArrayRef[Thingiverse::Thing]',      is => 'ro', required => 0, builder  => '_get_things_copied_by_user' );
# has downloads       => ( isa => 'ArrayRef[Thingiverse::Thing]',      is => 'ro', required => 0, builder  => '_get_things_downloaded_by_user' );
# has collections     => ( isa => 'ArrayRef[Thingiverse::Collection]', is => 'ro', required => 0, builder  => '_get_collections_created_by_user' );
# has avatarimage     => ( isa => 'Str',                       is => 'ro', required => 0, builder  => '_set_avatar_for_user' );
# has coverimage      => ( isa => 'Str',                       is => 'ro', required => 0, builder  => '_set_coverimage_for_user' );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'name'}) {
# print "just blessin' this user ya see: " . ${$_[0]}{'name'} . "\n";
# print Dumper($_[0]);
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'name'} ) { # passed a hashref to a hash containing key 'name'
    $name = ${$_[0]}{'name'};
	print "user name is $name\n";
  } elsif ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
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
  my $request = $api_base . ( $self->name || 'me' );
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_from_thingi_given_name {
  my $name = shift;
  my $request = $api_base . $name;
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_owned_by_user {
  my $self = shift;
  my $request = $api_base . $self->name . '/things';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
# Copy Pagination code from Category.pm
  return $return;
}

sub _get_things_liked_by_user {
  my $self = shift;
  my $request = $api_base . $self->name . '/likes';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
# Copy Pagination code from Category.pm
  return $return;
}

sub _get_copies_liked_by_user {
  my $self = shift;
  my $request = $api_base . $self->name . '/copies';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
# Copy Pagination code from Category.pm
  return $return;
}

sub _get_things_downloaded_by_user {
  my $self = shift;
  my $request = $api_base . $self->name . '/downloads';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
# Copy Pagination code from Category.pm
  return $return;
}

sub _get_collections_created_by_user {
  my $self = shift;
  my $request = $api_base . $self->name . '/collections';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
# Copy Pagination code from Category.pm
  return $return;
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
