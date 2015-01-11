#!/usr/bin/env perl

use Test::Most tests => 15 + 8;
use Data::Dumper;

use GAT;
use GAT::Comment;

my $id           = '547200';
my $target_id    = '630363';
my $target_type  = 'thing';
my $body         = qr(.*);
my $public_url   = sprintf 'http://www.thingiverse.com/%s:%s#comment-%s', $target_type, $target_id, $id;
my $url          = $GAT::api_uri_base . $GAT::Comment::api_base . $id;

my $comment = GAT::Comment->new( 'id' => $id );
# print Dumper($comment);

    ok( defined $comment,            'GAT::Comment object is defined' ); 
    ok( $comment->isa('GAT::Comment'), 'can make an GAT::Comment object' ); 
can_ok( $comment, qw( id ),          );
can_ok( $comment, qw( url ),         );
can_ok( $comment, qw( target_type ), );
can_ok( $comment, qw( target_id ),   );
can_ok( $comment, qw( public_url ),  );
can_ok( $comment, qw( target_url ),  );
can_ok( $comment, qw( body ),        );
can_ok( $comment, qw( user ),        );
can_ok( $comment, qw( added ),       );
can_ok( $comment, qw( modified ),    );
can_ok( $comment, qw( parent_id ),   );
can_ok( $comment, qw( parent_url ),  );
can_ok( $comment, qw( is_deleted ),  );

    is( $comment->id,                     $id,                     'id             accessor' ); 
  like( $comment->body,                   $body,                   'name           accessor' ); 
    is( $comment->public_url,             $public_url,             'public_url     accessor' ); 
cmp_ok( $comment->size,        "==",      $size,                   'size           accessor' ); 
    is( $comment->url,                    $url,                    'url            accessor' ); 
    is( $comment->parent_url,             $parent_url,             'parent_url     accessor' ); 
    is( ref($comment->user),              'HASH',                  'user           UserHash' ); 
    is( ${$comment->default_image}{id},   $commenter_id,           'user_id        accessor' ); 

if ( 0 ) {
  print "nocomment\n";
}

exit 0;
__END__

aliases:
commenter for user
