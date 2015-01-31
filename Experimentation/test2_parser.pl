#!/usr/bin/env perl
use strict;
use warnings;

  use DateTime;
  use DateTime::Format::ISO8601;
   

  my $date_string='2011-11-20T18:52:00+00:00';
  my $dt = DateTime::Format::ISO8601->parse_datetime( $date_string );
  print $dt->year . "\n";
__END__
Use of uninitialized value $input in concatenation (.) or string at /Library/Perl/5.16/DateTime/Format/Builder.pm line 154.
Invalid date format:  at ./test2_parser.pl line 8.
