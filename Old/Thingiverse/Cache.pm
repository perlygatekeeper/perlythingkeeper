package Thingiverse::User;
use Moose;
use Carp;
use Data::Dumper;

extends('Thingiverse');

our $object_ids = {
  User    => 'name',
  Thing   => 'id',
};

has _object_cache   => ( isa => 'HashRef', is => 'rw', required => 0, );

sub find_me_in_cache {
  my $self = shift;
  print "$self\n";
}

sub put_me_in_cache {
  my $self = shift;
  print "$self\n";
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
