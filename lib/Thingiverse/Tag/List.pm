package Thingiverse::Tag::List;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use Thingiverse;
use Thingiverse::Tag;
use Thingiverse::Types;
use Thingiverse::Pagination;

extends('Thingiverse');

our $api_base = "/things/%s/tags";

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
* L<Thingiverse::Cache>
* L<Thingiverse::Cache>
* L<Thingiverse::Category>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Comment>
* L<Thingiverse::Copy>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Group>
* L<Thingiverse::Image>
* L<Thingiverse::Image::List>
* L<Thingiverse::Pagination>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Tag>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
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

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my ( $tags, $thing_id, $json, $hash, $from_thingiverse,
       $request, $response, $link_header, $total_count, $pagination );

  if ( @_ == 1 && !ref $_[0] ) {
    $thing_id = $_[0];
  } elsif ( @_ == 2 && $_[0] =~ m'thing_id'i ) {
    $thing_id = $_[1];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'thing_id'} ) {
    $thing_id = ${$_[0]}{'thing_id'};
  } else {
    return $class->$orig(@_);
  }

  $request = sprintf $api_base, $thing_id;
  $from_thingiverse = _get_from_thingiverse($request);
  $response         = $from_thingiverse->{response};
  $json             = $response->responseContent;
  $tags             = decode_json($json);
  $pagination       = Thingiverse::Pagination->new( { response => $response, page => 1 } );
  if ( ref($tags) eq 'ARRAY' ) {
    foreach ( @{$tags} ) {
      $_->{'just_bless'} = 1;
      $_ = Thingiverse::Tag->new($_);
    }
  }
  $link_header = $response->responseHeader('Link');
  $hash->{tags}        = $tags;
  $hash->{request_url} = $request;
  $hash->{thing_id}    = $thing_id if ( $thing_id );
  $hash->{rest_client} = $from_thingiverse->{rest_client};
  return $hash;
};

# NEED A TRIGGER FOR CHANGE IN Pagination to make a new call to thingiverse!!!!

sub _get_from_thingiverse {
  my $request = shift;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  return { response => $response, rest_client => $rest_client };
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
