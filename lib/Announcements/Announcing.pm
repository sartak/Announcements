package Announcements::Announcing;
use Moose::Role;

has announcer => (
    is       => 'ro',
    isa      => 'Announcements::Announcer',
    lazy     => 1,
    required => 1,
    default  => sub {
        my $self = shift;
        Announcements::Announcer->new(
            owner => $self,
        ),
    },
);

1;

