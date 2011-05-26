package Announcements::SubscriptionRegistry;
use Moose;
use Announcements::Subscription;

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

    for my $subscription ($self->subscriptions) {
        $subscription->send($announcement, $announcer);
    }
}

1;

