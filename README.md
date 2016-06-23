# NAME

CPAN::Flatten - flatten cpan module requirements without install

# SYNOPSIS

    $ flatten --target-perl 5.10.1 --verbose Mojolicious
    Mojolicious (0) -> SRI/Mojolicious-6.66
      ExtUtils::MakeMaker (0) -> core
      ExtUtils::MakeMaker (0) -> core
      IO::Socket::IP (0.37) -> PEVANS/IO-Socket-IP-0.37
        Test::More (0.88) -> core
        IO::Socket (0) -> core
        Socket (1.97) -> core
      JSON::PP (2.27103) -> MAKAMAKA/JSON-PP-2.27400
        ExtUtils::MakeMaker (0) -> core
        ExtUtils::MakeMaker (0) -> core
        Test::More (0) -> core
      Pod::Simple (3.09) -> core
      Time::Local (1.2) -> core
      perl (5.010001) -> core

    S/SR/SRI/Mojolicious-6.66.tar.gz
      P/PE/PEVANS/IO-Socket-IP-0.37.tar.gz
      M/MA/MAKAMAKA/JSON-PP-2.27400.tar.gz
    P/PE/PEVANS/IO-Socket-IP-0.37.tar.gz
    M/MA/MAKAMAKA/JSON-PP-2.27400.tar.gz

# DESCRIPTION

This is experimental.

CPAN::Flatten flattens cpan module requirements without install.

As you know, the cpan world allows cpan modules to configure themselves dynamically.
So the actual requirements can not be determined
unless you install them to your local machines.

But, I think dynamic configuration is generally harmful,
and we should avoid that.

So what happens if we flattens cpan module requirements without install?

# AUTHOR

Shoichi Kaji <skaji@cpan.org>

# COPYRIGHT AND LICENSE

Copyright 2016 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
