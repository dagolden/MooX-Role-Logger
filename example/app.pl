use v5.10;
use strict;
use warnings;

use MyModule;

use Log::Any::Adapter ('Stdout');

my $obj = MyModule->new;
$obj->run;

