use Test::More;
use strict;
use warnings;

our $ANNOUNCEMENT;

{
    package Button;
    use Moose;
    with 'Announcements::Announcing';

    sub push {
        my $self = shift;

        $main::ANNOUNCEMENT = Announcements::Announcement->new;
        $self->announce($ANNOUNCEMENT);
    }
}

my $nuke = Button->new;

my ($inner_announcement, $inner_announcer, $inner_subscription);

use Announcements::Subscription;
my $subscription = Announcements::Subscription->new(
    criterion => 'Announcements::Announcement',
    action    => sub {
        ($inner_announcement, $inner_announcer, $inner_subscription) = @_;
        my $announcement = shift;

        isa_ok $announcement, 'Announcements::Announcement';
    },
);

$nuke->add_subscription($subscription);

$nuke->push;
is($inner_subscription, $subscription, 'same subscription object');
is($inner_announcer,    $nuke,         'same announcer object');
is($inner_announcement, $ANNOUNCEMENT, 'same announcement object');

done_testing;

