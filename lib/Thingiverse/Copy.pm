package Thingiverse::Copy;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;

use JSON;
use Thingiverse::Types;
use Thingiverse::Image;
use Thingiverse::User;

extends('Thingiverse');

our $api_base = "/copies/";

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
* L<Thingiverse::User>
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
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has id             => ( isa => 'ID',                      is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',                     is => 'ro', required => 0, );
has url            => ( isa => 'Str',                     is => 'ro', required => 0, );
has public_url     => ( isa => 'Str',                     is => 'ro', required => 0, );
has added          => ( isa => 'Str',                     is => 'ro', required => 0, );
has like_count     => ( isa => 'ThingiCount',             is => 'ro', required => 0, );
has description    => ( isa => 'Str',                     is => 'ro', required => 0, );
has is_liked       => ( isa => 'Any',                     is => 'ro', required => 0, );
has maker          => ( isa => 'Thingiverse::User',       is => 'ro', required => 0, );
has thumbnail      => ( isa => 'Str',                     is => 'ro', required => 0, );
has images_url     => ( isa => 'Str',                     is => 'ro', required => 0, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $id;
  my $json;
  my $hash;
  # first we check if we can by-pass making an API call to Thingiverse, since the hash was populated via a seperate call
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'id'}) {
#   print "just bless this thing!\n";
    delete ${$_[0]}{'just_bless'};
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    $id = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'id'} ) { # passed a hashref to a hash containing key 'id'
    $id = ${$_[0]}{'id'};
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

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
