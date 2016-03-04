use strict;
use warnings;

package MooX::Role::Logger;
# ABSTRACT: Provide logging via Log::Any
# VERSION

use Moo::Role;

use Log::Any ();

=method _logger

Returns a logging object.  See L<Log::Any> for a list of logging methods it accepts.

=cut

has _logger => (
    is       => 'lazy',
    isa      => sub { ref( $_[0] ) =~ /^Log::Any/ }, # XXX too many options
    init_arg => undef,
);

sub _build__logger {
    my ($self) = @_;
    return Log::Any->get_logger( category => "" . $self->_logger_category );
}

has _logger_category => ( is => 'lazy', );

=method _build__logger_category

Override to set the category used for logging.  Defaults to the class name of
the object (which could be a subclass).  You can override to lock it to a
particular name:

    sub _build__logger_category { __PACKAGE__ }

=cut

sub _build__logger_category { return ref $_[0] }

1;

=head1 SYNOPSIS

In your modules:

    package MyModule;
    use Moose;
    with 'MooX::Role::Logger';

    sub run {
        my ($self) = @_;
        $self->cry;
    }

    sub cry {
        my ($self) = @_;
        $self->_logger->info("I'm sad");
    }

In your application:

    use MyModule;
    use Log::Any::Adapter ('File', '/path/to/file.log');

    MyModule->run;

=head1 DESCRIPTION

This role provides universal logging via L<Log::Any>.  The class using this
role doesn't need to know or care about the details of log configuration,
implementation or destination.

Use it when you want your module to offer logging capabilities, but don't know
who is going to use your module or what kind of logging they will implement.
This role lets you do your part and leaves actual log setup and routing to
someone else.

The application that ultimately uses your module can then choose to direct log
messages somewhere based on its own needs and configuration with
L<Log::Any::Adapter>.

This role is based on L<Moo> so it should work with either L<Moo> or L<Moose>
based classes.

=head1 USAGE

=head2 Testing

Testing with L<Log::Any> is pretty easy, thanks to L<Log::Any::Test>.
Just load that before L<Log::Any> loads and your log messages get
sent to a test adapter that includes testing methods:

    use Test::More 0.96;
    use Log::Any::Test;
    use Log::Any qw/$log/;

    use lib 't/lib';
    use MyModule;

    MyModule->new->cry;
    $log->contains_ok( qr/I'm sad/, "got log message" );

    done_testing;

=head2 Customizing

If you have a whole set of classes that should log with a single category,
create your own role and set the C<_build__logger_category> there:

    package MyLibrary::Role::Logger;
    use Moo::Role;
    with 'MooX::Role::Logger';

    sub _build__logger_category { "MyLibrary" }

Then in your other classes, use your custom role:

    package MyLibrary::Foo;
    use Moo;
    with 'MyLibrary::Role::Logger'

=head1 SEE ALSO

Since MooX::Role::Logger is universal, you have to use it with one of
several L<Log::Any::Adapter> classes:

=for :list
* L<Log::Any::Adapter::File>
* L<Log::Any::Adapter::Stderr>
* L<Log::Any::Adapter::Stdout>
* L<Log::Any::Adapter::Screen>
* L<Log::Any::Adapter::Dispatch>
* L<Log::Any::Adapter::Syslog>
* L<Log::Any::Adapter::Log4perl>

These other logging roles are specific to particular logging packages, rather
than being universal:

=for :list
* L<MooseX::LazyLogDispatch>
* L<MooseX::Log::Log4perl>
* L<MooseX::LogDispatch>
* L<MooseX::Role::LogHandler>
* L<MooseX::Role::Loggable> (uses L<Log::Dispatchouli>)
* L<Role::Log::Syslog::Fast>

=cut

# vim: ts=4 sts=4 sw=4 et:
