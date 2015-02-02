package Thingiverse::Tag::List;
use Moose;
use Carp;
use JSON;
use Thingiverse;
use Thingiverse::Types;

has thing_id    => ( isa => 'ID',                      is => 'ro', required => 0, );
has request_url => ( isa => 'Str',                     is => 'ro', required => 0, );
has pagination  => ( isa => 'Thingiverse::Pagination', is => 'ro', required => 0, );

has tags  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Tag]',
  required => 0,
  handles  => {
    all_tags      => 'elements',
    add_tags      => 'push',
    map_tags      => 'map',
    filter_tags   => 'grep',
    find_tags     => 'grep',
    get_tags      => 'get',
    join_tags     => 'join',
    count_tags    => 'count',
    has_tags      => 'count',
    has_no_tags   => 'is_empty',
    sorted_tags   => 'sort',
  },
# lazy => 1,
);

sub _get_from_thingiverse {
  my $request = shift;
  print "calling thingiverse API asking for $request\n" if ($Thingiverse::verbose);
  my $rest_client = Thingiverse::_establish_rest_client('');
  my $response = $rest_client->GET($request);
  my $content = $response->responseContent;
  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__
