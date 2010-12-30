package Announcements::Announcer;
use Moose;

has owner => (
    is       => 'ro',
    isa      => 'Object',
    weak_ref => 1,
    required => 1,
);

has _subscriptions => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef[Announcements::Subscription]',
    default => sub { [] },
    lazy    => 1,
    handles => {
        subscriptions    => 'elements',
        add_subscription => 'push',
    },
);

sub announce {
    my $self         = shift;
    my $announcement = shift;

    $announcement->isa('Announcements::Announcement')
        or confess "announce must be passed only an instance of Announcements::Announcement";

    for my $subscription ($self->subscriptions) {
        $subscription->send($announcement);
    }
}

1;

