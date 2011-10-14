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
        subscriptions          => 'elements',
        _add_subscription      => 'push',
        _delete_subscription   => 'delete',
        _index_of_subscription => 'first_index',
    },
);

sub add_subscription {
    my $self = shift;
    my $subscription = $_[0];

    # autoreify add_subscription(foo => 1, bar => 2)
    if (!ref($subscription)) {
        $subscription = Announcements::Subscription->new(@_);
    }

    return $subscription if $subscription->_registry && $subscription->_registry == $self;

    $subscription->_registry($self);

    $self->_add_subscription($subscription);
    return $subscription;
}

sub announce {
    my $self         = shift;
    my $announcement = shift;
    my $announcer    = shift;

    # autoreify an announcement class name
    $announcement = $announcement->new if !ref($announcement);

    for my $subscription ($self->subscriptions) {
        $subscription->send($announcement, $announcer);
    }
}

sub unsubscribe {
    my $self = shift;
    my $subscription = shift;
    $self->_delete_subscription(
        $self->_index_of_subscription(sub {
            $_ == $subscription;
        })
    );
    $subscription->_clear_registry;
}

1;

__END__

=head1 NAME

Announcements::SubscriptionRegistry - a registry for an object's subscriptions

=cut

