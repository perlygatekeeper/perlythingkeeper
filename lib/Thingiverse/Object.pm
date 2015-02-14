package Thingiverse::Object;

use Moose;
use JSON;
use Thingiverse::Types;

sub thingiverse_attributes {
    my $this = shift; # should be a package
    my $attr = shift; # A hashref

    $this->meta->add_attribute(
        'thingiverse' => (
            is => 'ro',
            isa => 'Thingiverse',
            required => 1,
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
            my $request = $self->api_base() . $self->name();
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

    if ( $attr->{pk} ) {
        $this->meta->add_attribute(
            $attr->{pk} => (
                is => 'ro',
                isa => 'Str',
                required => 1,
            )
        );
    }

    for my $field ( keys %{$attr->{fields}} ) {
        $this->meta->add_attribute(
            $field => (
                is => 'ro',
                isa => $attr->{fields}->{$field},
                lazy_build => 1,
            )
        );

        $this->meta->add_method(
            "_build_$field" => sub {
                my $self = shift;
                return $self->content->{$field};
            }
        );
    }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
