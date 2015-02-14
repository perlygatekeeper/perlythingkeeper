package Thingiverse::Tag;

use Moose;

use Thingiverse::Types;

extends 'Thingiverse::Object';

# ABSTRACT: Thingiverse Tag Object

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

has things => (
  isa        => 'Thingiverse::Thing::List',
  is         => 'ro',
  required   => 0,
  builder    => '_get_things_tagged_with_tag',
  lazy       => 1
);

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/tags/',
        pk => 'name',
        fields => {
            count => 'ThingiCount',
            url => 'Str',
            things_url => 'Str',
        },
    }
);

sub _get_things_tagged_with_tag {
  my $self = shift;
  return Thingiverse::Thing::List->new(
    { api => 'search', term => $self->name });
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
special methods

list
