package user;
use Moose;
use Carp;

has              id => ( isa => 'Str',          is => 'ro', required => 1, );
has            name => ( isa => 'Str',          is => 'ro', required => 1, );
has      first_name => ( isa => 'Str',          is => 'ro', required => 0, );
has       last_name => ( isa => 'Str',          is => 'ro', required => 0, );
has       full_name => ( isa => 'Str',          is => 'ro', required => 0, );
has             url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has      public_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has       thumbnail => ( isa => 'Str',          is => 'ro', required => 0, );
has             bio => ( isa => 'Str',          is => 'ro', required => 0, );
has        location => ( isa => 'Str',          is => 'ro', required => 0, );
has      registered => ( isa => 'Date::Time',   is => 'ro', required => 0, );
has     last_active => ( isa => 'Date::Time',   is => 'ro', required => 0, );
has     cover_image => ( isa => 'Str',          is => 'ro', required => 0, );
has      things_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has      copies_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has       likes_url => ( isa => 'Str',          is => 'ro', required => 0, ); # change to type URL once it's made
has default_license => ( isa => 'Str',          is => 'ro', required => 0, );
has           email => ( isa => 'Str',          is => 'ro', required => 0, );
has    is_following => ( isa => 'Boolean',      is => 'ro', required => 0, );
# has           likes => ( isa => 'ArrayRef[thing]',      is => 'ro', required => 0, );
# has          things => ( isa => 'ArrayRef[thing]',      is => 'ro', required => 0, );
# has     collections => ( isa => 'ArrayRef[collection]', is => 'ro', required => 0, );
# has       downloads => ( isa => 'ArrayRef[thing]',      is => 'ro', required => 0, );
# has     avatarimage => ( isa => 'Str',                  is => 'ro', required => 0, );
# has      coverimage => ( isa => 'Str',                  is => 'ro', required => 0, );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
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
