#!/usr/bin/env perl
# A perl script to connect to thingiverse.com

my $name = $0; $name =~ s'.*/''; # remove path--like basename
my $usage = "usage:\n$name [-opt1] [-opt2] [-opt3]";

use strict;
use warnings;
use REST::Client;
use JSON;

my $rest_client = REST::Client->new( {
    'host'    => "https://api.thingiverse.com/",
	'timeout' => 300,   
	'follow'  => 0,
});
$rest_client->addHeader( 'Authorization', 'Bearer b053a0798c50a84fbb80e66e51bba9c4' );

my $response = $rest_client->GET("/users/perlygatekeeper/");
my $json = $response->responseContent;

print "$json\n\n";

my $user = decode_json($json);

print "$user->{id}\n";

exit 0;

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
