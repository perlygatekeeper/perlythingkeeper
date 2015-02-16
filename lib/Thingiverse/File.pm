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

# ABSTRACT: Thingiverse File Object

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
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/users/',
        pk => { id => { isa => 'ID' } },
        fields => {
            id             => { isa => 'ID' },
            name           => { isa => 'Str' },
            size           => { isa => 'Size' },
            url            => { isa => 'Str' },
            public_url     => { isa => 'Str' },
            download_url   => { isa => 'Str' },
            threejs_url    => { isa => 'Str' },
            default_image  => { isa => 'Any' },
            date           => { isa => 'ThingiverseDateTime', coerce => 1 },
            formatted_size => { isa => 'Str' },
            metadata       => { isa => 'ArrayRef' },
        }
    }
);

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

Two ways to get information from Thingiverse on a file:

1) explict request for a given file provided it's id:
   url: "https://api.thingiverse.com/files/389246"
2) as part of a returned array of files given a thing's id
   url: "https://api.thingiverse.com/things/209078/files"

Unlike some quantities, like  a user's info  vs.  a thing's creator's info,
file information is complete provided by both methods.
Therefore, files will not require a 'complete' method.
