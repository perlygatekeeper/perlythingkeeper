package GAT::Tag;
use Moose;
use Carp;
use JSON;
use GAT::Types;
# use GAT::User;

extends('GAT');
our $api_base = "/tags/";

has name           => ( isa => 'Str',               is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',               is => 'ro', required => 0, );
has count          => ( isa => 'ThingiCount',       is => 'ro', required => 0, );
has url            => ( isa => 'Str',               is => 'ro', required => 0, );
has things_url     => ( isa => 'Str',               is => 'ro', required => 0, );
has things         => ( isa => 'ArrayRef[HashRef]', is => 'ro', required => 0, builder => '_get_things_tagged_with_tag' );

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
  my $rest_client = GAT::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_things_tagged_with_tag {
  my $self = shift;
  my $request = $api_base . $self->name . '/things';
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  my $return = decode_json($content);
  return $return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
client_id( q(c587f0f2ee04adbe719b) );
access_token( q(b053a0798c50a84fbb80e66e51bba9c4) );

special methods

list
things

