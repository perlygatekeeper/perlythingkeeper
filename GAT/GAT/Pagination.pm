package GAT::Pagination;
use Moose;
use Carp;
use JSON;
use GAT::Types;

extends('GAT');

has page      => ( isa => 'Page',    is => 'ro', required => 0, default => 1 );
has per_page  => ( isa => 'PerPage', is => 'ro', required => 0, default => 30 );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && !ref $_[0] ) {
    # return $class->$orig( name => $_[0] );
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'name'} ) { # passed a hashref to a hash containing key 'name'
    $name = ${$_[0]}->{'name'};
  } elsif ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
    $name = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_from_thingi_given_name($name);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

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

{
		id: 16273
		name: "perlygatekeeper"
		first_name: "Steve"
		last_name: "Parker"
		full_name: "Steve Parker"
		url: "https://api.thingiverse.com/users/perlygatekeeper"
		public_url: "http://www.thingiverse.com/perlygatekeeper"
		thumbnail: "https://www.thingiverse.com/img/default/avatar/avatar_default_thumb_medium.jpg"
		bio: ""
		location: ""
		registered: "2011-11-20T18:52:00+00:00"
		last_active: "2015-01-03T01:39:45+00:00"
		cover_image: null
		things_url: "https://api.thingiverse.com/users/perlygatekeeper/things"
		copies_url: "https://api.thingiverse.com/users/perlygatekeeper/copies"
		likes_url: "https://api.thingiverse.com/users/perlygatekeeper/likes"
		default_license: "cc"
		email: "perlygatekeeper@gmail.com"
}
