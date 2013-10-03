use v5.10;
use strict;
use warnings;

package MooseX::Role::Logger;
# ABSTRACT: Provide logging via Log::Any
# VERSION

use Moo::Role;
use Types::Standard qw/InstanceOf Str/;

use Log::Any ();

=method logger

Returns a logging object.  See L<Log::Any> for a list of logging methods it accepts.

=cut

has logger => (
    is => 'lazy',
    # Log::Any::Proxy will be in next-gen Log::Any and replace Log::Any::Adapter::*
    isa =>
      InstanceOf [qw/Log::Any::Proxy Log::Any::Adapter::Base Log::Any::Adapter::Null/],
    init_arg => undef,
);

sub _build_logger {
    my ($self) = @_;
    return Log::Any->get_logger( category => $self->_logger_category );
}

has _logger_category => (
    is  => 'lazy',
    isa => Str,
);

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
    with 'MooseX::Role::Logger';

    sub run {
        my ($self) = @_;
        $self->cry;
    }

    sub cry {
        my ($self) = @_;
        $self->logger->info("I'm feeling sad");
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

This role is based on L<Moo> so should work with either L<Moo> or L<Moose>
based classes.

=head1 CUSTOMIZING

If you have a whole set of classes that should log with a single category,
create your own role and set the C<_build__logger_category> there:

    package MyLibrary::Role::Logger;
    use Moo::Role;
    with 'MooseX::Role::Logger';

    sub _build__logger_category { "MyLibrary" }

Then in your other classes, use your custom role:

    package MyLibrary::Foo;
    use Moo;
    with 'MyLibrary::Role::Logger'

=head1 SEE ALSO

=for :list
* L<MooseX::Role::Loggable>
* L<MooseX::Role::LogHandler>
* L<MooseX::Log::Log4perl>
* L<MooseX::Log::Dispatch>

=cut

# vim: ts=4 sts=4 sw=4 et:
