package Thingiverse::Pagination;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use Thingiverse::Types;

extends('Thingiverse');

# ABSTRACT: Pagination Object

=head1 SYNOPSIS

Contains attributes for the current page, the objects per_page (max of 30 imposed by the API), total_count of ojbects,
total number of pages, the response from the API call which returned the LIST of objects requiring pagination, and finally
the url strings or objects for the first, last, next, and previous pages.

---------

Note that these attributes are not all independent.  The per_page, total_count and pages attributes are related by the following
equations:

pages = ceil( total_count / per_page)

max( 30, floor( total_count / ( pages - 1 ) )  >=  per_page   >=  ceil(total_count/pages)  for example  (per_page = 25   total_count = 101  pages = 5)    101/4 = 25 1/4  and 101/5 = 20 + 1/5

pages * per_page   >=   total_count   >=   ( pages - 1 ) * per_page

Checks should be performed should the set_attribute method be called for any of these.    Could we require that all three be set at once?

---------

Upon setting the 'response' attribute, the response's headers are checked for 'Link' and 'Total-Count' headers and these
are used to adjust the other attributes.

---------

The XXX_url methods should really only be set via the _extract_pagination_links_from_responseHeaders private method.

Of course they could be easily returned at any point by a call to the as_string method after setting the page attribute appropriately.

We could have a method that would return the appropriate url-modifying string when given strings like:

qw( first last prev|previous curr|current next page=\d)

first   => return ''
last    => set this_page to $self->pages
curr    => set this_page to $self->page
prev    => set this_page to $self->page >     2 : ( $self->page - 1 )
                            $self->page =     2 : ''
                            $self->page <     2 : undef
next    => set this_page to $self->page < pages : ( $self->page + 1 )
                            $self->page = pages : undef
page=## =>                  ##          =     1 : ''
                            ##          >     1
							and        <= pages : page=## & per_page=$self->per_page

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
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

has page        => ( isa => 'Page',           is => 'ro', required => 0, default => 1 );
has per_page    => ( isa => 'PerPage',        is => 'ro', required => 0, default => $Thingiverse::pagination_maximum );
has pages       => ( isa => 'Page',           is => 'ro', required => 0, );
has total_count => ( isa => 'ThingiCount',    is => 'ro', required => 0, );
has response    => ( isa => 'ThingiResponse', is => 'rw', required => 0, trigger => \&_extract_pagination_links_from_responseHeaders, );
has first_url   => ( isa => 'Str',            is => 'ro', required => 0, );
has last_url    => ( isa => 'Str',            is => 'ro', required => 0, );
has prev_url    => ( isa => 'Str',            is => 'ro', required => 0, );
has next_url    => ( isa => 'Str',            is => 'ro', required => 0, );

sub as_string {
  my $self = shift;
  my ( $page, $per_page, $string );
  if ( $self->page > 1 ) {
    $page = "page=" . $self->page;
  }
  if ( $self->per_page < $Thingiverse::pagination_maximum ) {
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
  my $page;
  my $response = $self->response;
  my $link_header = $response->responseHeader('Link');
  if ($link_header and $link_header =~ /rel=.(first|last|next|prev)/) {
    foreach my $link ( split( /,\s*/, $link_header ) ) {
      my ($page_url, $page_label) = ( $link =~ /<([^>]+)>;\s+rel="([^"]+)"/);
      $self->{$page_label}=$page_url;
	  if ( not $page and $page_label =~ /next/i ) { # if we haven't determined the current page, and have a link for the next page
	    ( $page, ) = ( $page_url =~ /page=(\s+)/ ); # find the next page's number
		$page--;                                    # and subtract 1 to obtain the current page's number
	  }
	  if ( not $page and $page_label =~ /prev/i ) { # if we haven't determined the current page, and have a link for the previous page
	    ( $page, ) = ( $page_url =~ /page=(\s+)/ ); # find the previous page's number
		$page--;                                    # and add 1 to obtain the current page's number
	  }
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

