package Thingiverse::Thing;

use Moose;

use Thingiverse::Types;
use Thingiverse::User;
use Thingiverse::Thing::List;
use Thingiverse::Image;
use Thingiverse::Image::List;
use Thingiverse::Tag::List;

# ABSTRACT: defines attributes for a given object on thingiverse (called a thing).

=head1 SYNOPSIS

  ...

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
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

extends('Thingiverse::Object');

__PACKAGE__->thingiverse_attributes(
    {
        api_base => '/things/',
        pk => { 'id' => { isa => 'ID' } },
        fields =>  {
            name => { isa => 'Str' },
            instructions => { isa => 'Str' },
            instructions_html => { isa => 'Str' },
            description => { isa => 'Str' },
            description_html => { isa => 'Str' },
            is_wip => { isa => 'Any' },
            is_liked => { isa => 'Any' },
            is_private => { isa => 'Any' },
            in_library => { isa => 'Any' },
            is_featured => { isa => 'Any' },
            is_collected => { isa => 'Any' },
            is_purchased => { isa => 'Any' },
            is_published => { isa => 'Any' },
            added => { isa => 'Str' },
            modified => { isa => 'Str' },
            license => { isa => 'Str' },
            public_url => { isa => 'Str' },
            url => { isa => 'Str' },
            tags_url => { isa => 'Str' },
            images_url => { isa => 'Str' },
            categories_url => { isa => 'Str' },
            ancestors_url => { isa => 'Str' },
            derivatives_url => { isa => 'Str' },
            likes_url => { isa => 'Str' },
            layouts_url => { isa => 'Str' },
            files_url => { isa => 'Str' },
            thumbnail => { isa => 'Str' },
            like_count => { isa => 'ThingiCount' },
            file_count => { isa => 'ThingiCount' },
            layout_count => { isa => 'ThingiCount' },
            collect_count => { isa => 'ThingiCount' },
            print_history_count => { isa => 'ThingiCount' },
            creator => { isa => 'Thingiverse::User' },
            default_image => {isa => 'Thingiverse::Image' },
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

has prints               => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_prints_of_thing',       lazy => 1, );
has ancestors            => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_ancestors_of_thing',    lazy => 1, );
has derivatives          => ( isa => 'Thingiverse::Thing::List',    is => 'ro', required => 0, builder => '_get_derivatives_of_thing',  lazy => 1, );
has images               => ( isa => 'Thingiverse::Image::List',    is => 'ro', required => 0, builder => '_get_images_for_thing',      lazy => 1, );
has tags                 => ( isa => 'Thingiverse::Tag::List',      is => 'ro', required => 0, builder => '_get_tags_for_thing',        lazy => 1, );
has files                => ( isa => 'Thingiverse::File::List',     is => 'ro', required => 0, builder => '_get_files_for_thing',       lazy => 1, );
has likes                => ( isa => 'Thingiverse::User::List',     is => 'ro', required => 0, builder => '_get_users_who_liked_thing', lazy => 1, );
has categories           => ( isa => 'Thingiverse::Category::List', is => 'ro', required => 0, builder => '_get_categories_for_thing',  lazy => 1, );
# has app_id             => ( isa => 'ThingiID', ???
# has comments             => ( isa => 'Thingiverse::Comment::List',  is => 'ro', required => 0, builder => '_get_comments_on_thing',      lazy => 1, );
# has threadedcomments?

sub _get_prints_of_thing {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'prints', thing_id => $self->id , thingiverse => $self->thingiverse } );
}

sub _get_ancestors_of_thing {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'ancestors', thing_id => $self->id , thingiverse => $self->thingiverse } );
}

sub _get_derivatives_of_thing {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'derivatives', thing_id => $self->id , thingiverse => $self->thingiverse } );
}

# creator is made in teh BUILDARGS routine, builder not needed
sub _get_things_creator {
}

# default_image is also made in teh BUILDARGS routine, builder not needed
sub _get_things_default_image {
}

sub _get_images_for_thing {
  my $self = shift;
  return Thingiverse::Image::List->new( { thing_id => $self->id } );
}

sub _old_get_images_for_thing {
  my $self = shift;
  my $request = $self->api_base() . $self->id . '/images';
# Copy Pagination code from Category.pm
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  if ( ref($return) eq 'ARRAY' ) {
    my $cnt=0;
    foreach ( @{$return} ) {
      $_->{'thing_id'} = $self->id;
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Image->new($_);
    }
  }
  return $return;
}

sub _get_tags_for_thing {
  my $self = shift;
  return Thingiverse::Tag::List->new( { thing_id => $self->id } );
}

sub _old_get_tags_for_thing {
  my $self = shift;
  my $request = $self->api_base . $self->id . '/tags';
# Copy Pagination code from Category.pm
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  if ( ref($return) eq 'ARRAY' ) {
    foreach ( @{$return} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Tag->new($_);
    }
  }
  return $return;
}

sub _get_files_for_thing {
  my $self = shift;
  my $request = $self->api_base . $self->id . '/files';
# Copy Pagination code from Category.pm
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  if ( ref($return) eq 'ARRAY' ) {
    foreach ( @{$return} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::File->new($_);
    }
  }
  return $return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

sub list {
  return Thingiverse::Thing::List->new( 'things' );
}

sub newest {
  my $class = shift;
  return Thingiverse::Thing::List->new( 'newest' );
}

sub popular {
  return Thingiverse::Thing::List->new( 'popular' );
}

sub featured {
  return Thingiverse::Thing::List->new( 'featured' );
}

sub search {
  my $search_term = shift;
  return Thingiverse::Thing::List->new( { api => 'search', term => $search_term  } );
}

1;
__END__

# special methods which change state of Thing:
publish
like
unlike

# methods which return lists of meta-data objects
threadedcomments
comments
users_who_liked
files
images
packageurl

# related Things
ancestors
derivatives
copies

# Class methods or things.pm as well as thing.pm?
# return lists of Things
newest
featured
popular

search

