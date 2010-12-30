package Announcements::Announcing;
use Moose::Role;

has announcer => (
    is       => 'ro',
    isa      => 'Announcements::Announcer',
    default  => sub { Announcements::Announcer->new },
    lazy     => 1,
    required => 1,
);

1;

