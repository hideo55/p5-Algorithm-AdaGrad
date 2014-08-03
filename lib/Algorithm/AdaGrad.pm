package Algorithm::AdaGrad;
use 5.008005;
use strict;
use warnings;
use XSLoader;

BEGIN{
    our $VERSION = "0.01";
    XSLoader::load __PACKAGE__, $VERSION;
}


1;
__END__

=encoding utf-8

=head1 NAME

Algorithm::AdaGrad - It's new $module

=head1 SYNOPSIS

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
    

=head1 DESCRIPTION

Algorithm::AdaGrad is ...

=head1 LICENSE

Copyright (C) hideo55.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

hideo55 E<lt>hide.o.j55@gmail.comE<gt>

=cut

