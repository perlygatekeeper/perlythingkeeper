package Thingiverse::Copy;
use Moose;

use Thingiverse::Types;
use Thingiverse::Image;
use Thingiverse::User;

extends('Thingiverse::Object');

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
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/copies/',
        pk => { id => { isa => 'ID' } },
        fields => {
            url => { isa => 'Str' },
            public_url => { isa => 'Str' },
            added => { isa => 'Str' },
            like_count => { isa => 'ThingiCount' },
            description => { isa => 'Str' },
            is_liked => { isa => 'Any' },
            maker => { isa => 'Thingiverse::User' },
            thumbnail => { isa => 'Str' },
            images_url => { isa => 'Str' },
        },
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
