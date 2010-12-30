use Test::More;
use strict;
use warnings;

our $ANNOUNCEMENT;

{
    package Announcements::Announcement::Pushed;
    use Moose;
    extends 'Announcements::Announcement';
}

{
    package Button;
    use Moose;
    with 'Announcements::Announcing';

    sub push {
        my $self = shift;

        $main::ANNOUNCEMENT = Announcements::Announcement::Pushed->new;
        $self->announce($ANNOUNCEMENT);
    }
}

{
    package Spy;
    use Moose;
    with 'Announcements::Subscribing';
}

my $nuke = Button->new;
my $bond = Spy->new;

my ($inner_self, $inner_announcement, $inner_subscription);

my $subscription = $bond->subscribe(
    announcer => $nuke,
    criterion => 'Announcements::Announcement::Pushed',
    action    => sub {
        ($inner_self, $inner_announcement, $inner_subscription) = @_;

        my $self = shift;
        my $announcement = shift;

        isa_ok $announcement, 'Announcements::Announcement::Pushed';
    },
);

$nuke->push;
is($inner_self, $bond, 'same subscriber object');
is($inner_subscription, $subscription, 'same subscription object');
is($inner_announcement, $ANNOUNCEMENT, 'same announcement object');

is($subscription->subscriber, $bond, 'subscription->subscriber');
is($subscription->announcer, $nuke->announcer, 'subscription->announcer');

done_testing;

