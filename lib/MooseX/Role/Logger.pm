use strict;
use warnings;

package MooseX::Role::Logger;
# ABSTRACT: Provide logging via Log::Any (DEPRECATED)
# VERSION

use Moo::Role;
with 'MooX::Role::Logger';

1;

=head1 DESCRIPTION

L<MooseX::Role::Logger> has been renamed to L<MooX::Role::Logger> to clarify
that it works with both L<Moo> and L<Moose>.  This role just wraps that one and
is provided for backwards compatibility.

See L<MooX::Role::Logger> for usage details.

=cut

# vim: ts=4 sts=4 sw=4 et:
