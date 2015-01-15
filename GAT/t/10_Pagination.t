#!/usr/bin/env perl 

use Test::Most;
use Test::Exception;
use Data::Dumper;

use GAT;
use Thingiverse::Pagination;

my $page             = 2;
my $per_page         = 20;
my $default_per_page = 30;

my $pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } );

    ok( defined $pagination,               'Thingiverse::Pagination object is defined' ); 
    ok( $pagination->isa('Thingiverse::Pagination'),    'can make an GAT::Pagination object' ); 
can_ok( $pagination, qw( page ),                );
can_ok( $pagination, qw( per_page ),            );

  is( $pagination->page,                $page,                                'page       accessor' ); 
  is( $pagination->per_page,            $per_page,                            'per_page   accessor' ); 


$pagination = Thingiverse::Pagination->new();
is( $pagination->page,                  1,                                    'page default works' ); 
is( $pagination->per_page,              $default_per_page,                    'per_page default works' ); 

foreach $page ( 1 .. 10 ) {
  $pagination = Thingiverse::Pagination->new( { page => $page } );
  is( $pagination->page,                $page,                                "page number $page" ); 
}

$page      = 2;
$per_page  = 31;
throws_ok { $pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } )  }
qr/Attribute \(per_page\) does not pass the type constraint because: .* isn't an INT between 1 and 30 \(presently thingiverse.com limits pagination via it's API to a maximum of 30\)/,
"Thingiverse's API Pagination per_page upper limit of 30 is properly enforced.";

$per_page  = 0;
throws_ok { $pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } )  }
qr/Attribute \(per_page\) does not pass the type constraint because: .* isn't an INT between 1 and 30 \(presently thingiverse.com limits pagination via it's API to a maximum of 30\)/,
"Thingiverse's API Pagination per_page lower limit of 1 is properly enforced.";

$page      = 0;
throws_ok { $pagination = Thingiverse::Pagination->new( { page => $page } )  }
qr/Attribute \(page\) does not pass the type constraint because: .* isn't a positive int/,
"Thingiverse's API Pagination page lower limit of 1 is properly enforced.";

$page      = 1;
$per_page  = 30;
my $string    = '';
$pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } );
is( $pagination->as_string, $string, 'Thingiverse::Pagination object with defaults correctly returns empty string for API request URL parameters.');

$page      = 2;
$per_page  = 30;
$string    = "?page=$page";
$pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } );
is( $pagination->as_string, $string, "Thingiverse::Pagination object with  (page=$page)      and  per_page default correctly returns >> $string <<");

$page      = 1;
$per_page  = 20;
$string    = "?per_page=$per_page";
$pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } );
is( $pagination->as_string, $string, "Thingiverse::Pagination object with  page default  and  (per_page=$per_page)    correctly returns >> $string <<");

$page      = 4;
$per_page  = 20;
$string    = "?page=$page&per_page=$per_page";
$pagination = Thingiverse::Pagination->new( { page => $page, per_page => $per_page } );
is( $pagination->as_string, $string, "Thingiverse::Pagination object with  (page=$page)      and  (per_page=$per_page)    correctly returns >> $string <<  both parameters non-default, requiring use of &");


done_testing;

if ( 0 ) {
  print "nothing\n";
}

exit 0;
__END__
