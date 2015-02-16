package Thingiverse::Object;

use Moose;

use JSON;
use Thingiverse;

sub thingiverse_attributes {
    my $this = shift; # should be a package
    my $attr = shift; # A hashref

    my $primary_key = [ keys %{$attr->{pk}} ]->[0];

    $this->meta->add_attribute(
        'thingiverse' => (
            is => 'ro',
            isa => 'Thingiverse',
            default => sub { Thingiverse->new() },
            required => 0,
            handles => [ qw/rest_client/ ]
        )
    );

    $this->meta->add_method(
        'api_base' => sub {
            return $attr->{api_base};
        }
    );

    $this->meta->add_method(
        '_build_original_json' => sub {
            my $self = shift;
            my $request = $self->api_base() . $self->$primary_key();
            return $self->rest_client->GET($request)->responseContent;
        }
    );

    $this->meta->add_attribute(
        'original_json' => (
            is => 'ro',
            isa => 'Str',
            lazy_build => 1,
        )
    );

    $this->meta->add_method(
        '_build_content' => sub {
            my $self = shift;
            return JSON::decode_json($self->original_json);
        }
    );

    $this->meta->add_attribute(
        'content' => (
            is => 'ro',
            isa => 'HashRef',
            lazy_build => 1,
        )
    );

    if ( $primary_key ) {
        $this->meta->add_attribute(
            $primary_key => (
                is => 'ro',
                required => 1,
                %{$attr->{pk}->{$primary_key}},
            )
        );
    }

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
            %{$attrs},
        )
    );

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
