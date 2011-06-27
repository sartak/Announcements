use Test::More;
use strict;
use warnings;
use Announcements::Subscription;

{
    package PushedButton;
    use Moose;
    extends 'Announcements::Announcement';
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

subtest "One Subscription can subscribe to multiple announcers" => sub {
    local $TODO = "I think this should probably be allowed, but I'm not sure";
    my $red_button = PushedButton->new;
    my $green_button = PushedButton->new;

    my $guilty_party;

    my $subscription = Announcements::Subscription->new(
        when => 'PushedButton',
        do => sub {
            my($announcement, $announcer) = @_;
            $guilty_party = $announcer;
        },
    );

    $red_button->add_subscription($subscription);
    $green_button->add_subscription($subscription);

    $red_button->push;
    is $guilty_party, $red_button, "RED";
    $green_button->push;
    is $guilty_party, $green_button, "GREEN";

    $guilty_party = "NOTHING";

    $subscription->unsubscribe;
    $red_button->push;
    is $guilty_party, "NOTHING", "I got nothing";

    $guilty_party = "NOTHING";
    $green_button->push;
    is $guilty_party, "NOTHING", "Still nothing";
};

done_testing;


