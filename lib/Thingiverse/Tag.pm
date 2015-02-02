package Thingiverse::Tag;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use Thingiverse::Types;

extends('Thingiverse');

our $api_base = "/tags/";

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
* L<Thingiverse::Tag::List>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Category>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has name           => ( isa => 'Str',                      is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',                      is => 'ro', required => 0, );
has count          => ( isa => 'ThingiCount',              is => 'ro', required => 0, );
has url            => ( isa => 'Str',                      is => 'ro', required => 0, );
has things_url     => ( isa => 'Str',                      is => 'ro', required => 0, );
has things         => ( isa => 'Thingiverse::Thing::List', is => 'ro', required => 0, builder => '_get_things_tagged_with_tag', lazy => 1 );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'name'}) {
    delete ${$_[0]}{'just_bless'};
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    # return $class->$orig( name => $_[0] );
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'name'} ) { # passed a hashref to a hash containing key 'name'
    $name = ${$_[0]}{'name'};
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

sub _get_from_thingi_given_name {
  my $name = shift;
  my $request = $api_base . $name;
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_tagged_with_tag {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'search', term => $self->name  } );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
special methods

list
