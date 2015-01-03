package user;
use Moose;
use Carp;

has       user_name => ( isa => 'Str',   is => 'ro', required => 1, );
has      first_name => ( isa => 'Str',   is => 'ro', required => 0, );
has       last_name => ( isa => 'Str',   is => 'ro', required => 0, );
has             bio => ( isa => 'Str',   is => 'ro', required => 0, );
has        location => ( isa => 'Str',   is => 'ro', required => 0, );
has default_license => ( isa => 'Str',   is => 'ro', required => 0, );
# has           likes => ( isa => 'Array', is => 'ro', required => 0, );
# has          things => ( isa => 'Array', is => 'ro', required => 0, );
# has     collections => ( isa => 'Array', is => 'ro', required => 0, );
# has       downloads => ( isa => 'Array', is => 'ro', required => 0, );
# has     avatarimage => ( isa => 'Str',   is => 'ro', required => 0, );
# has      coverimage => ( isa => 'Str',   is => 'ro', required => 0, );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
client_id( q(c587f0f2ee04adbe719b) );
access_token( q(b053a0798c50a84fbb80e66e51bba9c4) );
