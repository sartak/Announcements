package Announcements::Subscription;
use Moose;

has announcer => (
    is       => 'ro',
    isa      => 'Announcements::Announcer',
    required => 1,
);

has subscriber => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

has criterion => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has action => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

sub send {
    my $self         = shift;
    my $announcement = shift;

    return unless $self->matches($announcement);

    $self->action->(
        $self->subscriber,
        $announcement,
        $self,
    );
}

sub matches {
    my $self         = shift;
    my $announcement = shift;

    # Moose makes ->DOES match ->isa, which is the default in newish perls but
    # provided by Moose if it's absent, *AND* ->does_role
    return $announcement->DOES($self->criterion);
}

1;

