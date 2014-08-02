use strict;
use warnings;
use Test::More;

use Algorithm::AdaGrad;

my $ag = Algorithm::AdaGrad->new(0.1);

$ag->update([
    { label => 1, data => { "a" => 1.0, } },
    { label => -1, data => { "b" => 1.5, } },
]);

is $ag->classify({ "a" => 1.0 }), 1;
is $ag->classify({ "b" => 1.0 }), -1;

done_testing();
