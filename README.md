# NAME

Algorithm::AdaGrad - It's new $module

# SYNOPSIS

    use Algorithm::AdaGrad;
    
    my $ag = Algorithm::AdaGrad->new(0.1);
    $ag->update([
        { "label" => 1,  "features" => { "R" => 1.0, "G" => 0.0, "B" => 0.0 } },
    ]);
    $ag->update([
        { "label" => -1, "features" => { "R" => 0.0, "G" => 1.0, "B" => 0.0 } },
        { "label" => -1, "features" => { "R" => 0,   "G" => 0,   "B" => 1 } },
        { "label" => -1, "features" => { "R" => 0.0, "G" => 1.0, "B" => 1.0 } },
        { "label" => 1,  "features" => { "R" => 1.0, "G" => 0.0, "B" => 1.0 } },
        { "label" => 1,  "features" => { "R" => 1.0, "G" => 1.0, "B" => 0.0 } }
    ]);
    

# DESCRIPTION

Algorithm::AdaGrad is ...

# LICENSE

Copyright (C) hideo55.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

hideo55 <hide.o.j55@gmail.com>
