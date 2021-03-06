use Test::More;
use strict;
use warnings;

{
    package Announcement::AboutToFlip;
    use Moose;
    extends 'Announcements::Announcement';

    has is_vetoed => (
        is      => 'rw',
        isa     => 'Bool',
        default => 0,
    );

    sub veto {
        my $self = shift;
        $self->is_vetoed(1);
    }
}

{
    package Light;
    use Moose;
    with 'Announcements::Announcing';

    has is_lit => (
        is      => 'rw',
        default => 0,
    );

    sub flip_switch {
        my $self = shift;

        my $announcement = Announcement::AboutToFlip->new;
        $self->announce($announcement);
        return if $announcement->is_vetoed;

        $self->is_lit(!$self->is_lit);
    }
}

my $light = Light->new;
ok(!$light->is_lit);

$light->flip_switch;
ok($light->is_lit);

$light->add_subscription(
    when => 'Announcement::AboutToFlip',
    do   => sub { },
);

$light->flip_switch;
ok(!$light->is_lit);

$light->add_subscription(
    when => 'Announcement::AboutToFlip',
    do   => sub { shift->veto },
);

$light->flip_switch;
ok(!$light->is_lit);

$light->flip_switch;
ok(!$light->is_lit);

done_testing;
