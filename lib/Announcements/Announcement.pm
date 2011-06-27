package Announcements::Announcement;
use Moose;

sub as_announcement {
    my $class = shift;
    return $class if blessed($class);
    return $class->new;
}

1;

__END__

=head1 NAME

Announcements::Announcement - superclass for announcement classes

=cut

