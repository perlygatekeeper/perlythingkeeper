package Thingiverse::User;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse::Types;
# use Thingiverse::Pagination;
use Thingiverse::Thing::List;
use Thingiverse::Collection::List;;

extends('Thingiverse');

our $api_base = "/users/";

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

=method method_x

This method does something experimental.

=method method_y

This method returns a reason.

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User::List>
* L<Thingiverse::Cache>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::Tag>
* L<Thingiverse::Tag::List>
* L<Thingiverse::Category>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Comment>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has id              => ( isa => 'ID',                            is => 'ro', required => 0, );
has _original_json  => ( isa => 'Str',                           is => 'ro', required => 0, );
has name            => ( isa => 'Str',                           is => 'ro', required => 1, );
has first_name      => ( isa => 'Str',                           is => 'ro', required => 0, );
has last_name       => ( isa => 'Str',                           is => 'ro', required => 0, );
has full_name       => ( isa => 'Str',                           is => 'ro', required => 0, );
has url             => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has public_url      => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has thumbnail       => ( isa => 'Str',                           is => 'ro', required => 0, );
has bio             => ( isa => 'Str',                           is => 'ro', required => 0, );
has location        => ( isa => 'Str',                           is => 'ro', required => 0, );
has registered      => ( isa => 'ThingiverseDateTime',           is => 'ro', required => 0, coerce  => 1 );
has last_active     => ( isa => 'ThingiverseDateTime',           is => 'ro', required => 0, coerce  => 1 );
has cover_image     => ( isa => 'Any',                           is => 'ro', required => 0, );
has things_url      => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has copies_url      => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has likes_url       => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has default_license => ( isa => 'Str',                           is => 'ro', required => 0, );
has email           => ( isa => 'Str',                           is => 'ro', required => 0, );
has is_following    => ( isa => 'Boolean',                       is => 'ro', required => 0, );
has things          => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_owned_by_user',        lazy => 1, );
has likes           => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_liked_by_user',        lazy => 1, );
has copies          => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_copied_by_user',       lazy => 1, );
has downloads       => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_downloaded_by_user',   lazy => 1, );
has collections     => ( isa => 'Thingiverse::Collection::List', is => 'ro', required => 0, builder => '_get_collections_created_by_user', lazy => 1, );
# has avatarimage     => ( isa => 'Str',                           is => 'ro', required => 0, builder => '_set_avatar_for_user',             lazy => 1, );
# has coverimage      => ( isa => 'Str',                           is => 'ro', required => 0, builder => '_set_coverimage_for_user',         lazy => 1, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  print "orig is >$orig< and class is >$class<\n" if ($Thingiverse::verbose > 1);
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'name'}) {
    print "just blessin' this user ya see: " . ${$_[0]}{'name'} . "\n" if ($Thingiverse::verbose);
    print Dumper($_[0]) if ($Thingiverse::verbose > 1);
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
  $json = _get_from_thingiverse_given_name($name);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_from_thingiverse {
  my $self = shift;
  my $request = $api_base . ( $self->name || 'me' );
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_from_thingiverse_given_name {
  my $name = shift;
  my $request = $api_base . $name;
  my $rest_client = Thingiverse::_establish_rest_client('');
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_owned_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'owned_by', term => $self->id, } );
}

sub _get_things_liked_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'liked_by', term => $self->id, } );
}

sub _get_copied_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'copied_by', term => $self->id, } );
}

sub _get_things_downloaded_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'downloaded_by', term => $self->id, } );
}

sub _get_collections_created_by_user {
  my $self = shift;
  return Thingiverse::Collection::List->new( { api => 'created_by', username => $self->name, } );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
