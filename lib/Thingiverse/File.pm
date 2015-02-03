package Thingiverse::File;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse::Types;

extends('Thingiverse');
our $api_base = "/files/";

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
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has id             => ( isa => 'ID',        is => 'ro', required => 1, );
has name           => ( isa => 'Str',       is => 'ro', required => 0, );
has size           => ( isa => 'Size',      is => 'ro', required => 0, );
has url            => ( isa => 'Str',       is => 'ro', required => 0, );
has public_url     => ( isa => 'Str',       is => 'ro', required => 0, );
has download_url   => ( isa => 'Str',       is => 'ro', required => 0, );
has threejs_url    => ( isa => 'Str',       is => 'ro', required => 0, );
has thumbnail      => ( isa => 'Str',       is => 'ro', required => 0, );
has date           => ( isa => 'Str',       is => 'ro', required => 0, );
has formated_size  => ( isa => 'Str',       is => 'ro', required => 0, );
has meta_data      => ( isa => 'ArrayRef',  is => 'ro', required => 0, );
has default_image  => ( isa => 'HashRef',   is => 'ro', required => 0, );
has _original_json => ( isa => 'Str',       is => 'ro', required => 0, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $id;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'id'}) {
    delete ${$_[0]}{'just_bless'};
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    $id = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'id'} ) { # passed a hashref to a hash containing key 'id'
    $id = ${$_[0]}->{'id'};
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

sub _get_from_thingi_given_id {
  my $id = shift;
  my $request = $api_base . $id;
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

Two ways to get information from Thingiverse on a file:

1) explict request for a given file provided it's id:
   url: "https://api.thingiverse.com/files/389246"
2) as part of a returned array of files given a thing's id
   url: "https://api.thingiverse.com/things/209078/files"

Unlike some quantities, like  a user's info  vs.  a thing's creator's info,
file information is complete provided by both methods.
Therefore, files will not require a 'complete' method.
   
