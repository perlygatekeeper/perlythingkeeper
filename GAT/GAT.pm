package GAT;
use Moose;
use Carp;
use REST::Client;

our api_uri_base = "https://api.thingverse.com/";

has client_id    => ( isa => 'Str', is => 'ro', required => 1, );
has access_token => ( isa => 'Str', is => 'ro', required => 1, );

# should I make rest_client an attribute or should I just have GAT use ISA = REST::Client?

has rest_client  => ( isa => '', is => ro, required => 1, builder => _establish_rest_client );

sub _establish_rest_client {
  my %config = {
    host    => $api_uri_base,
	timeout => 300,   # seconds
	follow  => 0,     # Boolean that determins whether REST::Client attempts to automatically follow redirects/authentication.
	@_, 
	# cert           => undef, # The path to a X509 certificate file to be used for client authentication.
	# key            => undef, # The path to a X509 key file to be used for client authentication.
	# ca             => undef, # The path to a certificate authority file to be used to verify host certificates.
	# pkcs12         => undef, # The path to a PKCS12 certificate to be used for client authentication.
	# useragent      => undef, # An LWP::UserAgent object, ready to make http requests.
	# pkcs12password => undef, # The password for the PKCS12 certificate specified with 'pkcs12'.
  }

}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

our client_id    = 'c587f0f2ee04adbe719b';
our access_token = 'b053a0798c50a84fbb80e66e51bba9c4';

REST::Client docs:

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
