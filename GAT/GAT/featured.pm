package featured;
use Moose;
use Carp;

has X => ( isa => 'Str', is => 'ro', required => 1, );


no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
client_id( q(c587f0f2ee04adbe719b) );
access_token( q(b053a0798c50a84fbb80e66e51bba9c4) );
