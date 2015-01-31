package GAT::Types::ThingID;

  use Moose::Util::TypeConstraints;

# oldest thing, thing_id == 7, was published on Oct 19, 2008
  subtype 'ThingID',
      as 'Int',
      where { $_ > 7 };

  no Moose::Util::TypeConstraints;
1;
