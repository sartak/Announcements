package Announcements::Subscribing;
use Moose::Role;
use Announcements::Subscription;

my $canonicalize_announcer = sub {
    my $announcer = shift;

    if ($announcer->isa('Announcements::Announcer')) {
        return $announcer;
    }

    if ($announcer->does('Announcements::Announcing')) {
        return $announcer->announcer;
    }

    confess "Not a valid announcer: $announcer";
};

sub subscribe {
    my $self = shift;
    my %args = (
        @_,
        subscriber => $self,
    );

    $args{announcer} = $canonicalize_announcer->($args{announcer});

    my $subscription = Announcements::Subscription->new(%args);

    $args{announcer}->add_subscription($subscription);

    return $subscription;
}

1;

