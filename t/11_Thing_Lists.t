#!/usr/bin/env perl 

use Test::Most tests => 12;
use Data::Dumper;

BEGIN {
    use_ok('Thingiverse');
    use_ok('Thingiverse::Thing');
}

my $newest_things = Thingiverse::Thing->newest( );
# print Dumper($newest_things);

    ok( defined $newest_things,            'Thingiverse::Thing object is defined' ); 
can_ok( $newest_things, qw( things ),      );
can_ok( $newest_things, qw( things_api ),  );
can_ok( $newest_things, qw( search_term ), );
can_ok( $newest_things, qw( thing_id ),    );
can_ok( $newest_things, qw( request_url ), );

    is( $newest_things->things_api,    'newest',     "api 'things'   given to Thingiverse::Thing::List was correct", );
    is( $newest_things->request_url,   '/newest/',   "correct request_url was generated", );

$newest_things = Thingiverse::Thing->popular( );
    is( $newest_things->things_api,    'popular',    "api 'popular'  given to Thingiverse::Thing::List was correct", );
    is( $newest_things->request_url,   '/popular/',  "correct request_url was generated", );

$newest_things = Thingiverse::Thing->featured( );
    is( $newest_things->things_api,    'featured',   "api 'featured' given to Thingiverse::Thing::List was correct", );
    is( $newest_things->request_url,   '/featured/', "correct request_url was generated", );

exit 0;
__END__
