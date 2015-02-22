package Thingiverse::Types;
use strict;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use Data::Dumper;
use Carp;
use JSON;
use DateTime;
use DateTime::Format::ISO8601;
use Thingiverse;

# ABSTRACT: Establishes the Types needed for the various Thingiverse/Moose object attributes

=head1 SYNOPSIS

  ...

=head1 SEE ALSO

=for :list
* L<Thingiverse>
* L<Thingiverse::User>
* L<Thingiverse::User::List>
* L<Thingiverse::Cache>
* L<Thingiverse::Thing>
* L<Thingiverse::Thing::List>
* L<Thingiverse::Tag>
* L<Thingiverse::Tag::List>
* L<Thingiverse::Category>
* L<Thingiverse::Collection>
* L<Thingiverse::Collection::List>
* L<Thingiverse::Comment>
* L<Thingiverse::File>
* L<Thingiverse::File::List>
* L<Thingiverse::Image>
* L<Thingiverse::SizedImage>
* L<Thingiverse::Copy>
* L<Thingiverse::Pagination>
* L<Thingiverse::Cache>
* L<Thingiverse::Group>
=cut

subtype 'ThingiCount',
  as 'Int',
  where { $_ >= 0 },
  message { "$_ is not a positive integer." };

# Thingiverse was started in November 2008[2] by Zach Smith as a companion site to MakerBot Industries, a DIY 3D printer kit making company.
# oldest thing, thing_id == 7, was published on Oct 19, 2008
subtype 'ThingiverseDateTime',
  as 'DateTime',
  where { $_ >= DateTime->new( year => 2008, month => 10, day => 18, hour => 0, minute => 0, second => 0) },
  message { "DateTime object isn't after Oct 18, 2008" };

# 2011-11-20T18:52:00+00:00
coerce 'ThingiverseDateTime',
  from 'Str',
  via {
      DateTime::Format::ISO8601->parse_datetime( $_ );
    };

# thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_large.jpg"
subtype 'TN',
  as 'URI',
  where { $_->host =~ m'thingiverse-production.s\d\.amazonaws\.com' and $_->method eq 'https' },
  message { "URI doesn't match /thingiverse-production.s3.amazonaws.com/" };

subtype 'Size',
  as 'Int',
  where { $_ > 0 },
  message { "$_ isn't an INT greater than 0" };

subtype 'ID',
  as 'Int',
  where { $_ > 0 },
  message { "$_ isn't an INT greater than 0" };

subtype 'OptionalID',
  as 'Any',
  where { ( ( $_ eq '' ) or ( $_ and $_ > 0 ) ) },
  message { "($_) isn't the null string nor an INT greater than 0" };

subtype 'ThingID',
  as 'Int',
  where { $_ > 7 },
  message { "$_ isn't an INT greater than 7 (earliest existing thingiverse.com thing)" };

subtype 'Page',
  as 'Int',
  where { $_ > 0 },
  message { "$_ isn't a positive int)" };

subtype 'PerPage',
  as 'Int',
  where { $_ >= 1 and $_ <= $Thingiverse::pagination_maximum },
  message { "$_ isn't an INT between 1 and $Thingiverse::pagination_maximum (presently thingiverse.com limits pagination via it's API to a maximum of 30)" };

subtype 'ThingiResponse',
  as 'REST::Client',
  where { $_->responseHeader('X-RateLimit-Remaining') and $_->responseHeader('X-RateLimit-Remaining') > 0 },
  message { "Well gee, this doesn't look like a valid REST API response from api.thingiverse.com ...\n"
          . join("\n",$_->responseHeaders()) . "\n>" . $_->responseHeader('X-RateLimit-Remaining') . "<" }; 

enum 'ThingiverseImageType', [ qw( thumb preview display ) ];

enum 'ThingiverseImageSize', [ qw( birdwing card featured large medium small tiny tinycard ) ];

enum 'Things_API',           [ qw( things search newest popular featured copies ancestors derivatives prints
                                   categorized_by collected_in tagged_as owned_by liked_by copied_by downloaded_by ) ];

enum 'Users_API',            [ qw( liked_by ) ];

enum 'Collections_API',      [ qw( created_by newest ) ];

no Moose::Util::TypeConstraints;
1;
__END__
