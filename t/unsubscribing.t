use Test::More;
use strict;
use warnings;

{
    package PushedButton;
    use Moose;
    with 'Announcements::Announcing';

    sub push {
        my $self = shift;

        $self->announce(PushedButton->new);
    }
}

subtest "Basic unsubscription" => sub {
    my $nuke = PushedButton->new;
    my $announcement_count = 0;

    ok my $subscription = $nuke->add_subscription(
        when => 'PushedButton',
        do => sub {
            $announcement_count++;
        }
    );

    isa_ok $subscription, 'Announcements::Subscription', '$nuke->add_subscription(...)';

    $nuke->push;

    is $announcement_count, 1;

    $subscription->unsubscribe;

    $nuke->push;

    is $announcement_count, 1;
};

subtest "Double subscription is wrong, m'kay?" => sub {
    my $nuke = PushedButton->new;
    my $announcement_count = 0;

    ok my $subscription = $nuke->add_subscription(
        when => 'PushedButton',
        do => sub {
            $announcement_count++;
        }
    );

    isa_ok $subscription, 'Announcements::Subscription', '$nuke->add_subscription(...)';
    $nuke->add_subscription($subscription);

    $nuke->push;
    is $announcement_count, 1, "Subscriptions only fire once per announcement";
};

done_testing;


