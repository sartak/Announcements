package Announcements::SubscriptionRegistry;
use Moose;

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
    my $announcer    = shift;

    # autovivify an announcement class name
    $announcement = $announcement->new if !ref($announcement);

    $announcement->isa('Announcements::Announcement')
        or confess "announce must be passed only an instance of Announcements::Announcement";

    for my $subscription ($self->subscriptions) {
        $subscription->send($announcement, $announcer);
    }
}

1;

