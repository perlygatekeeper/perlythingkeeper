#!/usr/bin/env perl
# A perl script to SCRIPT_DESCRIPTION

my $name = $0; $name =~ s'.*/''; # remove path--like basename
my $usage = "usage:\n$name [-opt1] [-opt2] [-opt3]";

use strict;
use warnings;

passed( name => 'steve' ) ;

exit 0;

sub passed {
  if ( @_ == 2 && $_[0] eq 'name' ) { # passed a hashref to a hash containing key 'name'
    print "yes!\n";
  } else {
    print "no!\n";
  }
}

__END__
