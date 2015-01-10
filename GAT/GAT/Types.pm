package GAT::Types;

  use Moose::Util::TypeConstraints;
  use DateTime;
  use DateTime::Format::ISO8601;

# Thingiverse was started in November 2008[2] by Zach Smith as a companion site to MakerBot Industries, a DIY 3D printer kit making company.
# oldest thing, thing_id == 7, was published on Oct 19, 2008
  subtype 'ThingiverseDateTime',
      as 'DateTime',
      where { $_ >= DateTime->new( year => 2008, month => 10, day => 18, hour => 0, minute => 0, second => 0) };

  coerce 'ThingiverseDateTime',
      from 'Str',
      via {
# 2011-11-20T18:52:00+00:00
        DateTime::Format::ISO8601->parse_datetime( $_ );
      };

# thumbnail: "https://thingiverse-production.s3.amazonaws.com/renders/d9/1f/cd/4d/e1/image1_thumb_large.jpg"

  subtype 'TN',
      as 'URI',
      where { $_->host =~ m'thingiverse-production.s\d\.amazonaws\.com' and $_->method eq 'https' };

  subtype 'Count',
      as 'Int',
      where { $_ >= 0 };

  subtype 'ID',
      as 'Int',
      where { $_ > 0 };

  subtype 'ThingID',
      as 'Int',
      where { $_ > 7 };

  no Moose::Util::TypeConstraints;
1;
