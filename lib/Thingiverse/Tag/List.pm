package Thingiverse::Tag::List;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use Thingiverse;
use Thingiverse::Types;

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

has thing_id    => ( isa => 'ID',                      is => 'ro', required => 0, );
has request_url => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination  => ( isa => 'Thingiverse::Pagination', is => 'ro', required => 0, );

has tags  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Tag]',
  required => 0,
  handles  => {
    all_tags      => 'elements',
    add_tags      => 'push',
    map_tags      => 'map',
    filter_tags   => 'grep',
    find_tags     => 'grep',
    get_tags      => 'get',
    join_tags     => 'join',
    count_tags    => 'count',
    has_tags      => 'count',
    has_no_tags   => 'is_empty',
    sorted_tags   => 'sort',
  },
# lazy => 1,
);

sub _get_from_thingiverse {
  my $request = shift;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
