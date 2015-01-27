package Thingiverse::Pagination;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;

extends('Thingiverse');

has page        => ( isa => 'Page',        is => 'ro', required => 0, default => 1 );
has per_page    => ( isa => 'PerPage',     is => 'ro', required => 0, default => 30 );
has pages       => ( isa => 'Page',        is => 'ro', required => 0, );
has thing_count => ( isa => 'ThingiCount', is => 'ro', required => 0, );

sub as_string {
  my $self = shift;
  my ( $page, $per_page, $string );
  if ( $self->page > 1 ) {
    $page = "page=" . $self->page;
  }
  if ( $self->per_page < 30 ) {
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

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

