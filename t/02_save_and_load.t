use strict;
use warnings;
use Test::More;
use Test::Fatal qw(exception lives_ok);
use File::Temp;

use Algorithm::AdaGrad;

subtest 'save_and_load' => sub {
    my $testdata = [
        { "label" => 1,  "data" => { "R" => 1.0, "G" => 0.0, "B" => 0.0 } },
        { "label" => -1, "data" => { "R" => 0.0, "G" => 1.0, "B" => 0.0 } },
        { "label" => -1, "data" => { "R" => 0,   "G" => 0,   "B" => 1 } },
        { "label" => -1, "data" => { "R" => 0.0, "G" => 1.0, "B" => 1.0 } },
        { "label" => 1,  "data" => { "R" => 1.0, "G" => 0.0, "B" => 1.0 } },
        { "label" => 1,  "data" => { "R" => 1.0, "G" => 1.0, "B" => 0.0 } }
    ];

    my $ag = Algorithm::AdaGrad->new(0.1);

    $ag->update($testdata);
    
    my $dumpfile = File::Temp->new();
    
    #lives_ok {
        $ag->save( $dumpfile->filename );
    #};
    
    my $ag2 = Algorithm::AdaGrad->new();
    lives_ok {
        $ag2->save( $dumpfile->filename );
    };
    
    
};

done_testing();