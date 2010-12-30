use Test::More;

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

        $self->announce(
            Announcements::Announcement::Pushed->new,
        );
    }
}

{
    package Spy;
    use Moose;
    with 'Announcements::Subscribing';
}

my $nuke = Button->new;
my $bond = Spy->new;

$bond->subscribe(
    announcer => $nuke,
    criterion => 'Announcements::Announcement::Pushed',
    action    => sub {
        my $self = shift;
        my $announcement = shift;
        isa_ok $announcement, 'Announcements::Announcement::Pushed';
    },
);

