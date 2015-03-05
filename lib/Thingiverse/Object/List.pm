package Thingiverse::Object::List;

use Moose;
use Moose::Util::TypeConstraints;

use JSON;
use Thingiverse;

# At first glance the Thingiverse::Object package
# ard the thingiverse_attributes method specifically
# could be generalized to handle EITHER a Thingiverse::Object
# OR a Thingiverse::Object::List.  And though this may have
# been straight forward and even easy to do, I felt it could
# only be done at the expense of the clairity of purpose and
# the readibility of the code.  I will therefore keep both
# concepts separate for now.


sub thingiverse_list_attributes {
    my $this = shift; # should be a package
    my $attr = shift; # A hashref

#   my $primary_key = [ keys %{$attr->{pk}} ]->[0];

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

	# api_bases (read_only) method
    $this->meta->add_method(
        'api_bases' => sub {
            my $api_name = shift;
            return $attr->{api_base}{$api_name};
        }
    );

    # response_json build method
    $this->meta->add_method(
        '_build_response_json' => sub {
            my $self = shift;
# request construction is more complicated than with a single Thingiverse::Object
            my $request = $self->api_base() . $self->$primary_key();
            return $self->rest_client->GET($request)->responseContent;
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

    # Add all other Attributes defined
    for my $field ( keys %{$attr->{fields}} ) {
        $this->_add_field(
            $field,
            $attr->{fields}->{$field},
        );
    }

}

# There are several types of fields/attributes:
#
# 1) standard fields, Int, Str
# 2) fields which will be must be coerced
#  - boolean from strings qw( true false)
#  - Thingiverse::DateTime from ISO8601-formatted string
# 3) Thingiverse objects, these are simply blessed apropriately into a via Thingiverse Object
#    Paul's done this in Collection.pm with BuildArgs for the creator (Thingiverse::User) object?
# 4) Lists of Thingiverse Objects.  ArrayRef[Thingiverse::Object]
# 5) Lists of Thingiverse Things.   ArrayRef[Thingiverse::Thing]
#    These are special.  Everything on Thingiverse comes down to the printable/cutable things.
#    There are 16 different API calls which lead to Lists of things.
#
# 3, 4 and 5 need not, and often don't involve objects with only a subset of the attributes that
# would be defined in an explicit request for that specific object.  The creator attributes, for
# instance do not return all of the attributes of a Thingiverse::User object.

sub _add_field {
    my $this = shift;
    my $field = shift;
    my $attrs = shift;
    $this->meta->add_attribute(
        $field => (
            is         => 'ro',
            required   => 0,
            lazy_build => 1,
            %{$attrs},         # this takes care of things like 'coerce => 1'
        )
    );
}

sub _add_list_field {
    my $this = shift;
    my $field = shift;
    my $attrs = shift;

    my $isa_list_of  = $attrs->{isa};
    my $isa          = "ArrayRef[$isa_list_of]";

    $this->meta->add_attribute(
        $field => (
            traits     => ['Array'],
            is         => 'ro',
			isa        => $isa,
            required   => 0,
			lazy_build => 1,
            handles  => {
                "all_"    . $field => 'elements',
                "add_"    . $field => 'push',
                "map_"    . $field => 'map',
                "filter_" . $field => 'grep',
                "find_"   . $field => 'grep',
                "get_"    . $field => 'get',
                "join_"   . $field => 'join',
                "count_"  . $field => 'count',
                "has_"    . $field => 'count',
                "has_no_" . $field => 'is_empty',
                "sorted_" . $field => 'sort',
            },
        )
    );

    if ( $attrs->{api} ) {       # this List of Thingiverse::Objects requires a call to the API
        $this->meta->add_method(
            "_build_$field" => sub {
                my $self = shift;
                return $isa->new(
                    %{$self->content->{$field}},
                    thingiverse => $self->thingiverse,
                );
            }
        );
    } else { # no API call needed, list of objects returned as result of a seperate API call
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
