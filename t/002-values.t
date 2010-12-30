use Test::More;
use strict;
use warnings;

{
    package Announcements::Announcement::ChangeValue;
    use Moose;
    extends 'Announcements::Announcement';

    has old_value => (
        is => 'ro',
    );

    has new_value => (
        is => 'ro',
    );
}

{
    package Switch;
    use Moose;
    with 'Announcements::Announcing';

    has state => (
        is      => 'rw',
        default => 'down',
        trigger => sub {
            my ($self, $new, $old) = @_;
            $self->announce(
                Announcements::Announcement::ChangeValue->new(
                    old_value => $old,
                    new_value => $new,
                ),
            );
        },
    );

    sub flip {
        my $self = shift;
        $self->state($self->state eq 'down' ? 'up' : 'down');
    }
}

{
    package Light;
    use Moose;

    has switch => (
        is      => 'ro',
        isa     => 'Switch',
        default => sub { Switch->new },
    );

    has is_lit => (
        is      => 'rw',
        isa     => 'Bool',
        default => 0,
    );

    sub BUILD {
        my $self = shift;
        use Announcements::Subscription;
        $self->switch->add_subscription(
            Announcements::Subscription->new(
                criterion => 'Announcements::Announcement::ChangeValue',
                action    => sub {
                    my $announcement = shift;
                    $self->is_lit($announcement->new_value eq 'up');
                },
            ),
        );
    }
}

my $overhead_light = Light->new;
is($overhead_light->switch->state, 'down');
ok(!$overhead_light->is_lit);

$overhead_light->switch->flip;
is($overhead_light->switch->state, 'up');
ok($overhead_light->is_lit);

$overhead_light->switch->flip;
is($overhead_light->switch->state, 'down');
ok(!$overhead_light->is_lit);

$overhead_light->switch->flip;
is($overhead_light->switch->state, 'up');
ok($overhead_light->is_lit);

done_testing;
