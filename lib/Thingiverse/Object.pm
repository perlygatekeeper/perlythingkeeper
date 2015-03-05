package Thingiverse::Object;

use Moose;
use Moose::Util::TypeConstraints;

use JSON;
use Thingiverse;

sub thingiverse_attributes {
    my $this = shift; # should be a package
    my $attr = shift; # A hashref

    my $primary_key = [ keys %{$attr->{pk}} ]->[0];

	# Thingiverse attribute
    $this->meta->add_attribute(
        'thingiverse' => (
            is => 'ro',
            isa => 'Thingiverse',
            default => sub { Thingiverse->new() },
            required => 0,
            handles => [ qw/rest_client/ ]
        )
    );

	# api_base (read_only) method
    $this->meta->add_method(
        'api_base' => sub {
            return $attr->{api_base};
        }
    );

    # response_json build method
    $this->meta->add_method(
        '_build_response_json' => sub {
            my $self = shift;
            my $request = $self->api_base() . $self->$primary_key();
			my $return = $self->rest_client->GET($request)->responseContent;
			{ # JSON collection temporary block
			  my $file = $request;
			  $file =~ s,^/,,;
			  $file =~ s,/,_,g;
			  my $outfile ="JSON/".$file;
			  if ( -f $outfile ) {
                open(OUTFILE, ">", $outfile) || die("I cannot write to '$outfile': $!\n");
                print OUTFILE $return;
                close(OUTFILE);
			  }
			}
            # return $self->rest_client->GET($request)->responseContent;
            return $return;
        }
    );

    # response_json attribute
    $this->meta->add_attribute(
        'response_json' => (
            is => 'ro',
            isa => 'Str',
            lazy_build => 1,
        )
    );

    # content attribute build method
    $this->meta->add_method(
        '_build_content' => sub {
            my $self = shift;
            return JSON::decode_json($self->response_json);
        }
    );

    # content attribute
    $this->meta->add_attribute(
        'content' => (
            is => 'ro',
            isa => 'HashRef',
            lazy_build => 1,
        )
    );

    # Primary Key 
    if ( $primary_key ) {
        $this->meta->add_attribute(
            $primary_key => (
                is => 'ro',
                required => 1,
                %{$attr->{pk}->{$primary_key}},
            )
        );
    }

    # Add all other Attributes defined
    for my $field ( keys %{$attr->{fields}} ) {
        $this->_add_field(
            $field,
            $attr->{fields}->{$field},
        );
    }
}

sub _add_field {
    my $this = shift;
    my $field = shift;
    my $attrs = shift;

    $this->meta->add_attribute(
        $field => (
            is => 'ro',
            lazy_build => 1,
            %{$attrs},         # this takes care of things like 'coerce => 1'
        )
    );

# There are several types of fields/attributes:
# 1) standard fields, Int, Str
# 2) fields which will be must be coerced
#  - boolean from strings qw( true false)
#  - Thingiverse::DateTime from ISO8601-formatted string
# 3) Thingiverse objects, these are simply blessed apropriately into a via Thingiverse Object
#    Paul's done this in Collection.pm with BuildArgs?
# 4) Lists of Thingiverse Objects.  ArrayRef[Thingiverse::Object]
# 5) Lists of Thingiverse Things.   ArrayRef[Thingiverse::Thing]
#    These are special.  Everything on Thingiverse comes down to the printable/cutable things.
#    There are 16 different API calls which lead to Lists of things.
    if ( $attrs->{isa} =~ /^Thingiverse::/ ) {
        my $isa = $attrs->{isa};
        eval "use $isa";
        $this->meta->add_method(
            "_build_$field" => sub {
                my $self = shift;
                return $isa->new(
                    %{$self->content->{$field}},
                    thingiverse => $self->thingiverse,
                );
            }
        );
    } else {
        $this->meta->add_method(
            "_build_$field" => sub {
                my $self = shift;
                return $self->content->{$field};
            }
        );
    }
}

sub has_list {
    my $this = shift;
    my $attrs = shift;
    my $name = [ keys %$attrs ]->[0];
    my $key = $attrs->{$name}->{key};
    my $api = $attrs->{$name}->{api};
    my $isa = $attrs->{$name}->{isa};
    my $search_arg = $attrs->{$name}->{search_arg};

    $this->meta->add_attribute(
        $name => (
            isa => $isa,
            is => 'ro',
            lazy_build => 1,
        )
    );

    $this->meta->add_method(
        "_build_$name" => sub {
            my $self = shift;
            return $isa->new(
                {
                    api => $api,
                    $search_arg => $self->$key,
                    thingiverse => $self->thingiverse,
                }
            );
        }
    );
}

__PACKAGE__->meta->make_immutable;

no Moose;
1;
__END__



has collections  => (
  traits   => ['Array'],
  is       => 'ro',
  isa      => 'ArrayRef[Thingiverse::Collection]',
  required => 0,
  handles  => {
    all_collections      => 'elements',
    add_collections      => 'push',
    map_collections      => 'map',
    filter_collections   => 'grep',
    find_collections     => 'grep',
    get_collections      => 'get',
    join_collections     => 'join',
    count_collections    => 'count',
    has_collections      => 'count',
    has_no_collections   => 'is_empty',
    sorted_collections   => 'sort',
  },
# lazy => 1,
);
