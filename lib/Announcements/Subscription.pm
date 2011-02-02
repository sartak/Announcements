package Announcements::Subscription;
use Moose;

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
    my $announcer    = shift;

    return unless $self->matches($announcement, $announcer);

    $self->action->(
        $announcement,
        $announcer,
        $self,
    );
}

sub matches {
    my $self         = shift;
    my $announcement = shift;

    # in perl 5.10+, ->DOES defaults to just ->isa. but Moose enhances ->DOES
    # (and provides that default on 5.8) to include ->does_role
    return $announcement->DOES($self->criterion);
}

1;

