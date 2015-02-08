package Thingiverse::Comment;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse::Types;

extends('Thingiverse');
our $api_base = "/comments/";

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

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
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has id             => ( isa => 'ID',                  is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',                 is => 'ro', required => 0, );
has url            => ( isa => 'Str',                 is => 'ro', required => 0, );
has target_id      => ( isa => 'ID',                  is => 'ro', required => 0, );
has public_url     => ( isa => 'Str',                 is => 'ro', required => 0, );
has target_type    => ( isa => 'Str',                 is => 'ro', required => 0, );
has target_url     => ( isa => 'Str',                 is => 'ro', required => 0, );
has body           => ( isa => 'Str',                 is => 'ro', required => 0, );
has user           => ( isa => 'User_Hash',           is => 'rw', required => 0, coerce => 1 );
has added          => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has modified       => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has parent_id      => ( isa => 'OptionalID',          is => 'ro', required => 0, );
has parent_url     => ( isa => 'Str',                 is => 'ro', required => 0, );
has is_deleted     => ( isa => 'Any',                 is => 'ro', required => 0, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $id;
  my $json;
  my $hash;
  if ( @_ == 1 && !ref $_[0] ) {
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
  my $rest_client = Thingiverse::_build_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
