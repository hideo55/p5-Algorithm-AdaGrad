use strict;
use warnings;
use Test::More;

use Algorithm::AdaGrad;

my $ag = Algorithm::AdaGrad->new(0.1);

$ag->update([
    { label => -1, data => { "a" => 0.4 } },
    { label => 1, data => { "a" => 0.4 } },
]);

ok(1);

done_testing();
