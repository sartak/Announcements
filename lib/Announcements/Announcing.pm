package Announcements::Announcing;
use Moose::Role;
use Announcements::Announcer;

has _announcer => (
    is       => 'ro',
    isa      => 'Announcements::Announcer',
    lazy     => 1,
    required => 1,
    default  => sub { Announcements::Announcer->new },
    handles  => ['add_subscription'],
);

sub announce {
    my $self = shift;
    my $announcement = shift;
    $self->_announcer->announce($announcement, $self);
}

1;

