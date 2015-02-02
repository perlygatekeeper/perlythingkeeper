package Thingiverse::Pagination;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;

extends('Thingiverse');

has page        => ( isa => 'Page',           is => 'ro', required => 0, default => 1 );
has per_page    => ( isa => 'PerPage',        is => 'ro', required => 0, default => $Thingiverse::pagination_maxium );
has pages       => ( isa => 'Page',           is => 'ro', required => 0, );
has total_count => ( isa => 'ThingiCount',    is => 'ro', required => 0, );
has response    => ( isa => 'ThingiResponse', is => 'rw', required => 0, trigger => \&_extract_pagination_links_from_responseHeaders, );
has first_url   => ( isa => 'Str',            is => 'ro', required => 0, builder => '_first_page_url', );
has last_url    => ( isa => 'Str',            is => 'ro', required => 0, builder => ' _last_page_url', );
has prev_url    => ( isa => 'Str',            is => 'ro', required => 0, builder => ' _prev_page_url', );
has next_url    => ( isa => 'Str',            is => 'ro', required => 0, builder => ' _next_page_url', );

sub as_string {
  my $self = shift;
  my ( $page, $per_page, $string );
  if ( $self->page > 1 ) {
    $page = "page=" . $self->page;
  }
  if ( $self->per_page < $Thingiverse::pagination_maxium ) {
    $per_page = "per_page=" . $self->per_page;
  }
  if ( $page || $per_page ) {
    if ( $page && $per_page ) {
      $string = $page . '&' . $per_page;
    } elsif ( $page ) {
      $string = $page;
    } else {
      $string = $per_page;
    }
    return '?' . $string;
  }
  return '';
}

sub _extract_pagination_links_from_responseHeaders {
  my $self = shift;
  my $response = $self->response;
  my $link_header = $response->responseHeader('Link');
  if ($link_header =~ /rel=.(first|last|next|prev)/) {
    foreach my $link ( split( /,\s*/, $link_header ) ) {
      my ($page_url, $page_label) = ( $link =~ /<([^>]+)>;\s+rel="([^"]+)"/);
      $self->{$page_label}=$page_url;
	  if ( $page_label =~ /last/i ) {
	    ( $self->{pages}, ) = ( $page_url =~ /page=(\d+)/i );
	  }
    }
  }
  $self->{total_count} = $response->responseHeader('Total-Count');
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

need to add extraction from header routine and work out how pages/thing_count can be interrelated.

sub _get_things_organized_under_category {
  my $self = shift;
  my $request = $api_base . $self->name . '/things'; # should be a Thingiverse::Thing::List
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
