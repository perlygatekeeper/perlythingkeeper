package Thingiverse::Collection;

use Moose;

use Thingiverse::Types;
use Thingiverse::Thing::List;
use Thingiverse::Collection::List;

extends('Thingiverse::Object');

# ABSTRACT: Thingiverse Collection Object

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

# two ways to get a list of Collections:
# /collections/                       with no added id, will give a list of the newest collections.
# /users/perlygatekeeper/collections  will give that user's collections

# two other calls to the API involving collections
# /collections/id                     give all information on collection designated by that id
# /collections/id/things              gives list of things belonging to that collection.

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/collections/',
        pk => { id => { isa => 'ID' } },
        fields => {
            name => { isa => 'Str' },
            description => { isa => 'Str' },
            url => { isa => 'Str' },
            thumbnail => { isa => 'Str' },
            thumbnail_1 => { isa => 'Str' },
            thumbnail_2 => { isa => 'Str' },
            thumbnail_3 => { isa => 'Str' },
            count => { isa => 'ThingiCount' },
            is_editable => { isa => 'Any' },
            added => { isa => 'ThingiverseDateTime', coerce => 1 },
            modified => { isa => 'ThingiverseDateTime', coerce => 1 },
            creator => { isa => 'Thingiverse::User' }
        }
    }
);

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    my $options = (ref($_[0]) eq 'HASH' ? $_[0] : { @_ });

    for my $i ( qw/creator/ ) {
        $options->{$i} = (
            ref($options->{$i}) eq 'HASH' ?
                Thingiverse::User->new(
                    %{$options->{$i}},
                    ( exists($options->{thingiverse}) ? (thingiverse => $options->{thingiverse}) : () )
                ) : $options->{$i}
            ) if ( exists($options->{$i}) );
    }
    $class->$orig($options);
};

__PACKAGE__->has_list(
    {
        'things' => {
            isa => 'Thingiverse::Thing::List',
            api => 'collected_in',
            search_arg => 'term',
            key => 'id',
        }
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;


sub newest {
  my $class = shift;
  return Thingiverse::Collection::List->new( 'newest' );
}

1;
__END__


{
  id: 2334425
  name: "Boxes and Containers"
  description: ""
  added: "2014-09-17T00:46:51+00:00"
  modified: "2014-09-17T00:47:03+00:00"
  creator: {
    id: 16273
    name: "perlygatekeeper"
    first_name: "Steve"
    last_name: "Parker"
    url: "https://api.thingiverse.com/users/perlygatekeeper"
    public_url: "http://www.thingiverse.com/perlygatekeeper"
    thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d3/5f/cb/0e/10/1524947_10202021360430593_1566936778_n_thumb_medium.jpg"
  }-
  url: "https://api.thingiverse.com/collections/2334425"
  count: 35
  is_editable: true
  thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_large.jpg"
  thumbnail_1: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_medium.jpg"
  thumbnail_2: "https://thingiverse-production.s3.amazonaws.com/renders/16/ae/be/7b/0e/IMG_20141223_215819_thumb_medium.jpg"
  thumbnail_3: "https://thingiverse-production.s3.amazonaws.com/renders/43/3c/d5/75/07/BoxOpenWithStopper2_thumb_medium.jpg"
}
