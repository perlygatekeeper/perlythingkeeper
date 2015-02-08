package Thingiverse::Cache;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

  ...

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
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
* L<Thingiverse::Group>
=cut

extends('Thingiverse');

our $object_ids = {
  User    => 'name',
  Thing   => 'id',
};

has _object_cache   => ( isa => 'HashRef', is => 'rw', required => 0, );

sub find_me_in_cache {
  my $self = shift;
  print "$self\n";
}

sub put_me_in_cache {
  my $self = shift;
  print "$self\n";
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
