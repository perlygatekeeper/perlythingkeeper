package GAT::Comment;
use Moose;
use Carp;
use JSON;
use GAT::Types;

extends('GAT');
our $api_base = "/comments/";

has id             => ( isa => 'ID',                  is => 'ro', required => 1, );
has _original_json => ( isa => 'Str',                 is => 'ro', required => 0, );
has url            => ( isa => 'Str',                 is => 'ro', required => 0, );
has target_id      => ( isa => 'ID',                  is => 'ro', required => 0, );
has public_url     => ( isa => 'Str',                 is => 'ro', required => 0, );
has target_type    => ( isa => 'Str',                 is => 'ro', required => 0, );
has target_url     => ( isa => 'Str',                 is => 'ro', required => 0, );
has body           => ( isa => 'Str',                 is => 'ro', required => 0, );
has user           => ( isa => 'User_Hash',           is => 'rw', required => 0, coerce => 1 );
has added          => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has modified       => ( isa => 'ThingiverseDateTime', is => 'ro', required => 0, coerce => 1 );
has parent_id      => ( isa => 'ID',                  is => 'ro', required => 0, );
has parent_url     => ( isa => 'Str',                 is => 'ro', required => 0, );
has is_deleted     => ( isa => 'Any',                 is => 'ro', required => 0, );

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $id;
  my $json;
  my $hash;
  if ( @_ == 1 && !ref $_[0] ) {
    $id = $_[0];
  } elsif ( @_ == 1 && ref $_[0] eq 'HASH' && ${$_[0]}->{'id'} ) { # passed a hashref to a hash containing key 'id'
    $id = ${$_[0]}->{'id'};
  } elsif ( @_ == 2 && $_[0] eq 'id' ) { # passed a hashref to a hash containing key 'id'
    $id = $_[1];
  } else {
    return $class->$orig(@_);
  }
  $json = _get_from_thingi_given_id($id);
  $hash = decode_json($json);
  $hash->{_original_json} = $json;
  return $hash;
};

sub _get_from_thingi_given_id {
  my $id = shift;
  my $request = $api_base . $id;
  my $rest_client = GAT::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response ->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
{
  id: 547200
  url: "https://api.thingiverse.com/comments/547200"
  target_type: "thing"
  target_id: 630363
  public_url: "http://www.thingiverse.com/thing:630363#comment-547200"
  target_url: "https://api.thingiverse.com/thing/630363"
  body: "http://www.dailymail.co.uk/news/article-2904490/A-nation-mourning-Thousands-pay-tribute-terror-victims-France-floral-tributes-laid-outside-Jewish-deli-four-hostages-lost-lives.html "
  user: {
    id: 322875
    name: "LizHavlin"
    first_name: "Liz"
    last_name: "Havlin"
    url: "https://api.thingiverse.com/users/LizHavlin"
    public_url: "http://www.thingiverse.com/LizHavlin"
    thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/b6/41/9f/39/18/liz_9-2014_thumb_medium.jpg"
  }-
  added: "2015-01-11T05:35:46+00:00"
  modified: ""
  parent_id: ""
  parent_url: ""
  is_deleted: false
}
