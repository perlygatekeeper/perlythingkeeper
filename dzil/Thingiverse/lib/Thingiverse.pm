package Thingiverse;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use REST::Client;

my $VERSION="0.6.1";

# ABSTRACT: library to interface with Thingiverse's REST API:

=head1 Base Class for client library to interface with Thingiverse's REST API

//http://www.thingiverse.com/developers/rest-api-reference

Main purposes for this base class is to hold global values like the api_uri_base, 
pagination maxium, debug/verbosity flags for debugging, and the access_token used
for authentication/authorization to the API.  It also serves to make and store
the rest_client attribute which all the sub classes will need and use.

=method method_x

This method does something experimental.

=method method_y

This method returns a reason.

=head1 SEE ALSO

=for :list
* L<Thingiverse::User>
* L<Thingiverse::Thing>
* L<Thingiverse::Tag>
* L<Thingiverse::Collection>
* L<Thingiverse::Category>
* L<Thingiverse::File>
* L<Thingiverse::Image>

=cut

our $api_uri_base      = "https://api.thingiverse.com";
our $pagination_maxium = 30;
our $verbose           = 2;

our $client_id         = 'c587f0f2ee04adbe719b';
our $access_token      = 'b053a0798c50a84fbb80e66e51bba9c4';

# should I make rest_client an attribute or should I just have GAT use ISA = REST::Client? or extends REST::Client
has rest_client  => ( isa => 'REST::Client', is => 'ro', required => 1, builder => '_establish_rest_client', lazy => 1 );

sub _establish_rest_client {
  my $self = shift;
  if ( not $self or ( $self and  not $self->{rest_client} ) ) {
    my %config = (
      'host'    => $api_uri_base,
      'timeout' => 300,   # seconds
      'follow'  => 0,     # Boolean that determins whether REST::Client attempts to automatically follow redirects/authentication.
      @_, 
      # cert           => undef, # The path to a X509 certificate file to be used for client authentication.
      # key            => undef, # The path to a X509 key file to be used for client authentication.
      # ca             => undef, # The path to a certificate authority file to be used to verify host certificates.
      # pkcs12         => undef, # The path to a PKCS12 certificate to be used for client authentication.
      # useragent      => undef, # An LWP::UserAgent object, ready to make http requests.
      # pkcs12password => undef, # The password for the PKCS12 certificate specified with 'pkcs12'.
    );
    my $rest_client = REST::Client->new(%config);
    $rest_client->addHeader( 'Authorization', 'Bearer ' . $access_token );
    return $rest_client;
  }
}

sub _send_request_to_thingiverse {
  my $self = shift;
  my $request = shift;

  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $response = $self->rest_client->GET($request);

# NEED TO ADD ERROR HANDLING HERE!!!

# my $content = $response->responseContent;
# my $headers = $response->responseHeaders;
  return $response;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

REST::Client docs for easy access while coding:
Should move this to Notes as markdown

Request Methods

Each of these methods makes an HTTP request, sets the internal state of the object, and returns the object.

They can be combined with the response methods, such as:

  print $client->GET('/search/?q=foobar')->responseContent();


* GET ( $url, [%$headers] )
  Preform an HTTP GET to the resource specified. Takes an optional hashref of custom request headers.

* PUT ($url, [$body_content, %$headers] )
  Preform an HTTP PUT to the resource specified. Takes an optional body content and hashref of custom request headers.

* PATCH ( $url, [$body_content, %$headers] )
  Preform an HTTP PATCH to the resource specified. Takes an optional body content and hashref of custom request headers.

* POST ( $url, [$body_content, %$headers] )
  Preform an HTTP POST to the resource specified. Takes an optional body content and hashref of custom request headers.

* DELETE ( $url, [%$headers] )
  Preform an HTTP DELETE to the resource specified. Takes an optional hashref of custom request headers.

* OPTIONS ( $url, [%$headers] )
  Preform an HTTP OPTIONS to the resource specified. Takes an optional hashref of custom request headers.

* HEAD ( $url, [%$headers] )
  Preform an HTTP HEAD to the resource specified. Takes an optional hashref of custom request headers.

* request ( $method, $url, [$body_content, %$headers] )
  Issue a custom request, providing all possible values.

Response Methods

Use these methods to gather information about the last requset performed.

* responseCode ()
  Return the HTTP response code of the last request

* responseContent ()
  Return the response body content of the last request

* responseHeaders()
  Returns a list of HTTP header names from the last response

* responseHeader ( $header )
  Return a HTTP header from the last response

* responseXpath ()
  A convienience wrapper that returns a XML::LibXML xpath context for the body content. Assumes the content is XML.

has rest_client  => ( isa => 'REST::Client', is => 'ro', required => 1, builder => '_establish_rest_client', lazy => 1 );
