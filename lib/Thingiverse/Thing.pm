package Thingiverse::Thing;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;

use JSON;
use Thingiverse::Types;
use Thingiverse::Thing::List;
use Thingiverse::User;
use Thingiverse::Image;
use Thingiverse::Tag;

# ABSTRACT: defines attributes for a given object on thingiverse (called a thing).

=head1 SYNOPSIS

  ...

=method method_x

This method does something experimental.

=method method_y

This method returns a reason.

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
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

extends('Thingiverse');
our $api_base = "/things/";

has id                   => ( isa => 'ID',                       is => 'ro', required => 1, );
has _original_json       => ( isa => 'Str',                      is => 'ro', required => 0, );
has name                 => ( isa => 'Str',                      is => 'ro', required => 0, );
has instructions         => ( isa => 'Str',                      is => 'ro', required => 0, );
has instructions_html    => ( isa => 'Str',                      is => 'ro', required => 0, );
has description          => ( isa => 'Str',                      is => 'ro', required => 0, );
has description_html     => ( isa => 'Str',                      is => 'ro', required => 0, );
has is_wip               => ( isa => 'Any',                      is => 'ro', required => 0, );
has is_liked             => ( isa => 'Any',                      is => 'ro', required => 0, );
has is_private           => ( isa => 'Any',                      is => 'ro', required => 0, );
has in_library           => ( isa => 'Any',                      is => 'ro', required => 0, );
has is_featured          => ( isa => 'Any',                      is => 'ro', required => 0, );
has is_collected         => ( isa => 'Any',                      is => 'ro', required => 0, );
has is_purchased         => ( isa => 'Any',                      is => 'ro', required => 0, );
has is_published         => ( isa => 'Any',                      is => 'ro', required => 0, );
has added                => ( isa => 'Str',                      is => 'ro', required => 0, );
has modified             => ( isa => 'Str',                      is => 'ro', required => 0, );
has license              => ( isa => 'Str',                      is => 'ro', required => 0, );
has creator              => ( isa => 'Thingiverse::User',           is => 'ro', required => 0, builder => '_get_things_creator',        lazy => 1, );
has prints               => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_prints_of_thing',       lazy => 1, );
has ancestors            => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_ancestors_of_thing',    lazy => 1, );
has derivatives          => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_derivatives_of_thing',  lazy => 1, );
has images               => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_images_for_thing',      lazy => 1, );
has tags                 => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_tags_for_thing',        lazy => 1, );
has files                => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_files_for_thing',       lazy => 1, );
has likes                => ( isa => 'Thingiverse::User::List',     is => 'ro', required => 0, builder => '_get_users_who_liked_thing', lazy => 1, );
has categories           => ( isa => 'Thingiverse::Category::List', is => 'ro', required => 0, builder => '_get_categories_for_thing',  lazy => 1, );
# has comments/threadedcomments
has public_url           => ( isa => 'Str',                      is => 'ro', required => 0, );
has url                  => ( isa => 'Str',                      is => 'ro', required => 0, );
has tags_url             => ( isa => 'Str',                      is => 'ro', required => 0, );
has images_url           => ( isa => 'Str',                      is => 'ro', required => 0, );
has categories_url       => ( isa => 'Str',                      is => 'ro', required => 0, );
has ancestors_url        => ( isa => 'Str',                      is => 'ro', required => 0, );
has derivatives_url      => ( isa => 'Str',                      is => 'ro', required => 0, );
has likes_url            => ( isa => 'Str',                      is => 'ro', required => 0, );
has layouts_url          => ( isa => 'Str',                      is => 'ro', required => 0, );
has files_url            => ( isa => 'Str',                      is => 'ro', required => 0, );
has thumbnail            => ( isa => 'Str',                      is => 'ro', required => 0, );
has like_count           => ( isa => 'ThingiCount',              is => 'ro', required => 0, );
has file_count           => ( isa => 'ThingiCount',              is => 'ro', required => 0, );
has layout_count         => ( isa => 'ThingiCount',              is => 'ro', required => 0, );
has collect_count        => ( isa => 'ThingiCount',              is => 'ro', required => 0, );
has print_history_count  => ( isa => 'ThingiCount',              is => 'ro', required => 0, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $id, $json, $hash, $creator );
  # first we check if we can by-pass making an API call to Thingiverse, since the hash was populated via a seperate call
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'id'}) {
#   delete ${$_[0]}{'just_bless'};
    print "just blessing a thing-like hash with thing_id: " . ${$_[0]}{'id'} . "\n" if ($Thingiverse::verbose);
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    $id = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'id'} ) { # passed a hashref to a hash containing key 'id'
    $id = ${$_[0]}{'id'};
    print "we got ourselves a lookup for thing_id: $id\n" if ($Thingiverse::verbose);
  } elsif ( @_ == 2 && $_[0] eq 'id' ) { # passed a hashref to a hash containing key 'id'
    $id = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_from_thingi_given_id($id);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  $creator = $hash->{creator}; # this will be a HashRef containing keys appropo for a Thingiverse::User
  $creator->{just_bless} = 1;
  $hash->{creator} = Thingiverse::User->new( $creator );
  return $hash;
};

sub _get_from_thingi_given_id {
  my $id = shift;
  my $request = $api_base . $id;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

sub _get_prints_of_thing {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'prints', thing_id => $self->id } );
}

sub _get_ancestors_of_thing {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'ancestors', thing_id => $self->id } );
}

sub _get_derivatives_of_thing {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'derivatives', thing_id => $self->id } );
}

sub _get_images_for_thing {
  my $self = shift;
  my $request = $api_base . $self->id . '/images';
# Copy Pagination code from Category.pm
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  if ( ref($return) eq 'ARRAY' ) {
    my $cnt=0;
    foreach ( @{$return} ) {
      $_->{'thing_id'} = $self->id;
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Image->new($_);
    }
  }
  return $return;
}

sub _get_tags_for_thing {
  my $self = shift;
  my $request = $api_base . $self->id . '/tags';
# Copy Pagination code from Category.pm
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  if ( ref($return) eq 'ARRAY' ) {
    foreach ( @{$return} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Tag->new($_);
    }
  }
  return $return;
}

sub _get_files_for_thing {
  my $self = shift;
  my $request = $api_base . $self->id . '/files';
# Copy Pagination code from Category.pm
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  if ( ref($return) eq 'ARRAY' ) {
    foreach ( @{$return} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::File->new($_);
    }
  }
  return $return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

sub list {
# return Thingiverse::Thing::List->new( { api => 'things' } );
# return Thingiverse::Thing::List->new( api => 'things' );
  return Thingiverse::Thing::List->new( 'things' );
}

sub newest {
  my $class = shift;
  return Thingiverse::Thing::List->new( 'newest' );
}

sub popular {
  return Thingiverse::Thing::List->new( 'popular' );
}

sub featured {
  return Thingiverse::Thing::List->new( 'featured' );
}

sub search {
  my $search_term = shift;
  return Thingiverse::Thing::List->new( { api => 'search', term => $search_term  } );
}

# sub ancestors {
#   my $thing_id = shift;
#   return Thingiverse::Thing::List->new( { api => 'ancestors', thing_id => $thing_id  } );
# }
# 
# sub derivatives {
#   my $thing_id = shift;
#   return Thingiverse::Thing::List->new( { api => 'derivatives', thing_id => $thing_id  } );
# }
# 
# sub prints {
#   my $thing_id = shift;
#   return Thingiverse::Thing::List->new( { api => 'prints', thing_id => $thing_id  } );
# }

1;
__END__

# special methods which change state of Thing:
publish
like
unlike

# methods which return lists of meta-data objects
threadedcomments
comments
users_who_liked
files
images
packageurl

# related Things
ancestors
derivatives
copies

# Class methods or things.pm as well as thing.pm?
# return lists of Things
newest
featured
popular

search
