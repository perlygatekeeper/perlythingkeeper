#!/usr/bin/env perl

  use strict;
  use warnings;
  use DateTime;
  use DateTime::Format::Builder;
  use DateTime::Format::Builder::Parser;
  use DateTime::Format::Builder::Parser::Regex;

  my $date_string='2011-11-20T18:52:00+00:00';
  my $parser = DateTime::Format::Builder->create_parser(
    {
       regex  => qr/^(20\d\d)-([01]\d)-([0123]\d)T([012]\d):([0-6]\d):([0-6]\d)\+\d\d:\d\d$/,
       params => [ qw( year month day hour minute second ) ],
    },
  );
   my $dt = $parser->parse( date => $date_string );
#  my $dt = $parser->parse_datetime( $date_string );
  print $dt->year . "\n";
__END__
Use of uninitialized value $input in concatenation (.) or string at /Library/Perl/5.16/DateTime/Format/Builder.pm line 154.
Invalid date format:  at ./test_parser.pl line 15.
