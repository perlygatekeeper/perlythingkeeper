package Thingiverse::Thing::List;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse;
use Thingiverse::Types;
use Thingiverse::Thing;
use Thingiverse::Pagination;

extends('Thingiverse');

# ABSTRACT: a really awesome library

=head1 SYNOPSIS

Each of these 16 API's returns a list of Thingiverse::Things
and will benefit from the traits of ['Array'] provided by
Moose::Meta::Attribute::Native::Trait::Array

Four of these API's need additional information
search                          API needs a search term
ancestors, derivates and prints APIs all need a thing_id
owned_by, liked_by,
copied_by and downloaded_by     APIs all need a user_name
tagged_as                       API requires a tag name

  search
  newest
  popular
  featured
  copies
  ancestors
  derivatives
  prints
  categorized_by
  collected_in
  tagged_as
  owned_by
  liked_by
  copied_by
  downloaded_by

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
* L<Thingiverse::Thing>
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


our $api_bases = {
  things         => "/things/",
  search         => "/search/%s",
  newest         => "/newest/",
  popular        => "/popular/",
  featured       => "/featured/",
  copies         => '/copies',
  ancestors      => '/things/%s/ancestors',
  derivatives    => '/things/%s/derivatives',
  prints         => '/things/%s/prints',
  categorized_by => '/categories/%s/things',
  collected_in   => '/collections/%s/things',
  tagged_as      => '/tags/%s/things',
  owned_by       => '/users/%s/things',
  liked_by       => '/users/%s/likes',
  copied_by      => '/users/%s/copies',
  downloaded_by  => '/users/%s/downloads',
};

has things_api  => ( isa => 'Things_API',              is => 'ro', required => 1, );
has search_term => ( isa => 'Str',                     is => 'ro', required => 0, );
has thing_id    => ( isa => 'ID',                      is => 'ro', required => 0, );
has request_url => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination  => ( isa => 'Thingiverse::Pagination', is => 'rw', required => 0, );

has things  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Thing]',
  required => 0,
  handles  => {
    all_things      => 'elements',
    add_things      => 'push',
    map_things      => 'map',
    filter_things   => 'grep',
    find_things     => 'grep',
    get_things      => 'get',
    join_things     => 'join',
    count_things    => 'count',
    has_things      => 'count',
    has_no_things   => 'is_empty',
    sorted_things   => 'sort',
  },
# lazy => 1,
);

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $api, $term, $things, $thing_id, $json, $hash, $from_thingiverse,
       $request, $response, $link_header, $total_count, $pagination );
  if ( @_ == 1 && !ref $_[0] ) {
    $api = $_[0];
  } elsif ( @_ == 2 && $_[0] =~ m'api'i ) {
    $api = $_[1];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'api'} ) { # passed a hashref to a hash containing key 'api'
    $api      = ${$_[0]}{'api'};
    $term     = ${$_[0]}{'term'};
    $thing_id = ${$_[0]}{'thing_id'};
  } else {
# not sure what to do here
    return $class->$orig(@_);
  }
# Now decide what to do.
  if      ( $api =~ qr(things|newest|featured|popular|copies) ) {
    $request = $api_bases->{$api};
  } elsif ( $api =~ qr(ancestors|derivatives|prints) ) {
    $request = sprintf $api_bases->{$api}, $thing_id;
  } elsif ( $api =~ qr(search|categorized|collected|tagged|owned|liked|copied|downloaded) ) {
    $request = sprintf $api_bases->{$api}, $term;
  } else {
    die "API specified ($api) not know to return list of things.";
  }
  $from_thingiverse = _get_from_thingiverse($request);
  $response         = $from_thingiverse->{response};
  $json             = $response->responseContent;
  $things           = decode_json($json);
  $pagination       = Thingiverse::Pagination->new( { response => $response, page => 1 } );
  if ( ref($things) eq 'ARRAY' ) {
    foreach ( @{$things} ) {
      $_->{creator}{just_bless}=1;
      $_->{creator} = Thingiverse::User->new($_->{creator});
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Thing->new($_);
    }
  }
  $link_header = $response->responseHeader('Link');
  $hash->{things}      = $things;
  $hash->{things_api}  = $api;
  $hash->{request_url} = $request;
  $hash->{term}        = $term     if ( $term ); 
  $hash->{thing_id}    = $thing_id if ( $thing_id ); 
  $hash->{rest_client} = $from_thingiverse->{rest_client};
  return $hash;
};

# NEED A TRIGGER FOR CHANGE IN Pagination to make a new call to thingiverse!!!!

sub _get_from_thingiverse {
  my $request = shift;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $rest_client = Thingiverse::_build_rest_client('');
  my $response = $rest_client->GET($request);
  return { response => $response, rest_client => $rest_client };
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

# Related Things
ancestors
derivatives
copies
prints

# Class methods or things.pm as well as thing.pm?
# returns lists of Things
newest
featured
popular

search

things (without an id)

Other objects generate a List of things as well:
categories  - categorized_as
collections - collected_in
tags        - tagged_by
users       - owned_by, liked_by, collected_by and downloaded_by

Need Pagination work for this one.

Could do the same (or something similar) for Categories, Collections, Tags, Images, Files and Users.

sub _get_things_organized_under_category {
  my $self = shift;
  my $request = $api_base . $self->name . '/things'; # should be a Thingiverse::Thing::List
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $link_header = $response->responseHeader('Link');
  my $return = decode_json($content);
  if ($link_header =~ /rel=.(first|last|next|prev)/) {
    my $pagination;
    foreach my $link ( split( /,\s*/, $link_header ) ) {
      my ($page_url, $page_label) = ( $link =~ /<([^>]+)>;\s+rel="([^"]+)"/);
      $pagination->{$page_label}=$page_url;
    }
    $self->things_pagination($pagination);
  }
  return $return;
}
