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

  subtype 'ThingID',
      as 'Int',
      where { $_ > 7 };

  no Moose::Util::TypeConstraints;
1;
