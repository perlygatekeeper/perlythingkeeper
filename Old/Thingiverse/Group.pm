package Thingiverse::Group;
use Moose;
use Carp;
use JSON;
use Thingiverse::Types;
use Data::Dumper;

extends('Thingiverse');
extends('Thingiverse::User');
extends('Thingiverse::User::List');
our $api_base = "/groups/";

has id              => ( isa => 'ID',                            is => 'ro', required => 0, );
has _original_json  => ( isa => 'Str',                           is => 'ro', required => 0, );
has name            => ( isa => 'Str',                           is => 'ro', required => 1, );
has description     => ( isa => 'Str',                           is => 'ro', required => 0, );
has posted_things   => ( isa => 'Str',                           is => 'ro', required => 0, );
has featured_things => ( isa => 'Str',                           is => 'ro', required => 0, );
has posts           => ( isa => 'Str',                           is => 'ro', required => 0, );
has url             => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has public_url      => ( isa => 'Str',                           is => 'ro', required => 0, ); # change to type URL once it's made
has thumbnail       => ( isa => 'Str',                           is => 'ro', required => 0, );
has members         => ( isa => 'Thingiverse::User::List',       is => 'ro', required => 0, );


around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  print "orig is >$orig< and class is >$class<\n" if ($Thingiverse::verbose > 1);
  my $name;
  my $json;
  my $hash;
  if ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'just_bless'} && ${$_[0]}{'name'}) {
  print "just blessin' this user ya see: " . ${$_[0]}{'name'} . "\n" if ($Thingiverse::verbose);
  print Dumper($_[0]) if ($Thingiverse::verbose > 1);
    return $class->$orig(@_);
  } elsif ( @_ == 1 && !ref $_[0] ) {
    $name = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}{'name'} ) { # passed a hashref to a hash containing key 'name'
    $name = ${$_[0]}{'name'};
	print "user name is $name\n";
  } elsif ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
    $name = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_from_thingiverse_given_name($name);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_from_thingiverse {
  my $self = shift;
  my $request = $api_base . ( $self->name || 'me' );
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

sub _get_from_thingiverse_given_id {
  my $name = shift;
  my $request = $api_base . $id;
  my $rest_client = Thingiverse::_establish_rest_client('');
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
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
