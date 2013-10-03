use 5.008001;
use strict;
use warnings;

package MyModule;

use Moo;
with 'MooseX::Role::Logger';

sub cry {
    my ($self) = @_;
    $self->logger->info("I'm sad");
}

1;

