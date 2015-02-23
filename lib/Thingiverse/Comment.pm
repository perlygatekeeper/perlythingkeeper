package Thingiverse::Comment;

use Moose;

use Thingiverse::Types;

extends('Thingiverse::Object');

# ABSTRACT: Thingiverse Comment Object

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

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/comments/',
        pk => { 'id' => { isa => 'ID' } },
        fields => {
            target_id   => { isa => 'ID' },
            url         => { isa => 'Str' },
            public_url  => { isa => 'Str' },
            target_type => { isa => 'Str' },
            target_url  => { isa => 'Str' },
            body        => { isa => 'Str' },
            user        => { isa => 'Thingiverse::User',   coerce => 1, is => 'rw' },
            added       => { isa => 'ThingiverseDateTime', coerce => 1 },
            modified    => { isa => 'ThingiverseDateTime', coerce => 1 },
            is_deleted  => { isa => 'Boolean',             coerce => 1 },
            parent_id   => { isa => 'OptionalID' },
            parent_url  => { isa => 'Str' },
        },
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
