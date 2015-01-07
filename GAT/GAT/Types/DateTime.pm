package GAT::Types::DateTime;

  use Moose::Util::TypeConstraints;
  use DateTime;
  use DateTime::Format::Builder;

# Thingiverse was started in November 2008[2] by Zach Smith as a companion site to MakerBot Industries, a DIY 3D printer kit making company.
# oldest thing, thing_id == 7, was published on Oct 19, 2008
  subtype 'ThingiverseDateTime',
      as 'DateTime',
      where { $_ >= DateTime->new( year => 2008, month => 10, day => 18, hour => 0, minute => 0, second => 0) };

  coerce 'ThingiverseDateTime',
      from 'Str',
      via {
        # 2011-11-20T18:52:00+00:00
        my $parser = DateTime::Format::Builder->create_parser(
          regex  => qr/^(20\d\d)-([01]\d)-([0123]\d)T([012]\d):([0-6]\d):([0-6]\d)\+\d\d:\d\d$/,
          params => [ qw( year month day hour minute second ) ],
        );
        my $dt = $parser->parse_datetime( $_ );
        $dt;
      };

  no Moose::Util::TypeConstraints;
1;
