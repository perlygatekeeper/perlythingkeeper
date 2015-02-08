package Thingiverse::Tag;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;
# use Thingiverse::User;

extends('Thingiverse');
our $api_base = "/tags/";

has name           => ( isa => 'Str',                      is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',                      is => 'ro', required => 0, );
has count          => ( isa => 'ThingiCount',              is => 'ro', required => 0, );
has url            => ( isa => 'Str',                      is => 'ro', required => 0, );
has things_url     => ( isa => 'Str',                      is => 'ro', required => 0, );
has things         => ( isa => 'Thingiverse::Thing::List', is => 'ro', required => 0, builder => '_get_things_tagged_with_tag', lazy => 1 );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'name'}) {
    delete ${$_[0]}{'just_bless'};
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    # return $class->$orig( name => $_[0] );
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'name'} ) { # passed a hashref to a hash containing key 'name'
    $name = ${$_[0]}{'name'};
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

sub _get_from_thingi_given_name {
  my $name = shift;
  my $request = $api_base . $name;
  my $rest_client = Thingiverse::_build_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_tagged_with_tag {
  my $self = shift;
  return Thingiverse::Thing::List->new( { api => 'search', term => $self->name  } );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
special methods

list
