package Thingiverse::User;

use Moose;
use Thingiverse::Types;
use Thingiverse::Thing::List;
use Thingiverse::Collection::List;;

extends('Thingiverse::Object');

our $api_base = "/users/";

# ABSTRACT: Thingiverse User Object

=head1 SYNOPSIS

  ...

=head1 SEE ALSO

=for :list
* L<Thingiverse>
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
        api_base => '/users/',
        pk => { name => { isa => 'Str' } },
        fields => {
            id              => { isa => 'ID'  },
            first_name      => { isa => 'Str' },
            last_name       => { isa => 'Str' },
            full_name       => { isa => 'Str' },
            url             => { isa => 'Str' },
            public_url      => { isa => 'Str' },
            thumbnail       => { isa => 'Str' },
            bio             => { isa => 'Str' },
            location        => { isa => 'Str' },
            cover_image     => { isa => 'Any' },
            things_url      => { isa => 'Str' },
            copies_url      => { isa => 'Str' },
            likes_url       => { isa => 'Str' },
            default_license => { isa => 'Str' },
            email           => { isa => 'Str' },
            registered      => { isa => 'ThingiverseDateTime', coerce => 1 },
            last_active     => { isa => 'ThingiverseDateTime', coerce => 1 },
            is_following    => ( isa => 'Boolean',             coerce => 1 },
        }
    }
);

has things          => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_owned_by_user',        lazy => 1, );
has likes           => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_liked_by_user',        lazy => 1, );
has copies          => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_copied_by_user',       lazy => 1, );
has downloads       => ( isa => 'Thingiverse::Thing::List',      is => 'ro', required => 0, builder => '_get_things_downloaded_by_user',   lazy => 1, );
has collections     => ( isa => 'Thingiverse::Collection::List', is => 'ro', required => 0, builder => '_get_collections_created_by_user', lazy => 1, );

sub _get_from_thingiverse {
  my $self = shift;
  my $request = $api_base . ( $self->name || 'me' );
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_from_thingiverse_given_name {
  my $name = shift;
  my $request = $api_base . $name;
  my $rest_client = Thingiverse::_build_rest_client('');
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_owned_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'owned_by', term => $self->id, } );
}

sub _get_things_liked_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'liked_by', term => $self->id, } );
}

sub _get_copied_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'copied_by', term => $self->id, } );
}

sub _get_things_downloaded_by_user {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'downloaded_by', term => $self->id, } );
}

sub _get_collections_created_by_user {
  my $self = shift;
  return Thingiverse::Collection::List->new( { api => 'created_by', username => $self->name, } );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
