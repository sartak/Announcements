package Announcements::Subscription;
use Moose;

has when => (
    is            => 'ro',
    isa           => 'Str',
    required      => 1,
    documentation => 'a class or role name to filter announcements',
);

has do => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

has _registry => (
    is => 'rw',
    isa => 'Announcements::SubscriptionRegistry',
    weak_ref => 1,
    clearer => '_clear_registry',
    init_arg => undef,
);


sub send {
    my $self         = shift;
    my $announcement = shift;
    my $announcer    = shift;

    return unless $self->matches($announcement, $announcer);

    $self->do->(
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
    return $announcement->DOES($self->when);
}

sub unsubscribe {
    my $self = shift;
    $self->_registry->unsubscribe($self);
}

1;

__END__

=head1 NAME

Announcements::Subscription - a subscription to a class of announcements

=cut

