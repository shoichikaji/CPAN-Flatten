package CPAN::Flatten;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use CPAN::Flatten::Distribution::Factory;
use CPAN::Flatten::Distribution;

sub new {
    my ($class, %opt) = @_;
    bless {%opt}, $class;
}

sub info_progress {
    my ($self, $depth) = (shift, shift);
    print STDERR "  " x $depth, "-> @_";
}
sub info_done {
    shift;
    print STDERR ", @_\n";
}

sub flatten {
    my ($self, $package, $version) = @_;
    my $distribution = CPAN::Flatten::Distribution->new;
    my $miss = +{};
    $self->_flatten($distribution, $miss, $package, $version);
    wantarray ? ($distribution, $miss) : $distribution;
}


sub _flatten {
    my ($self, $distribution, $miss, $package, $version) = @_;
    return if $miss->{$package};
    return if CPAN::Flatten::Distribution->is_core($package, $version);
    my $already = $distribution->root->providing($package, $version);
    if ($already) {
        $distribution->add_child( $already->dummy );
        return;
    }

    $self->info_progress($distribution->depth, "Searching distribution for $package");
    my ($found, $reason) = CPAN::Flatten::Distribution::Factory->from_pacakge($package, $version);
    if (!$found) {
        $miss->{$package}++;
        $self->info_done($reason);
        return;
    }
    $self->info_done("found @{[$found->distfile]}");
    $distribution->add_child($found);
    for my $requirement (@{$found->requirements}) {
        $self->_flatten($found, $miss, $requirement->{package}, $requirement->{version});
    }
    return;
}

1;
__END__

=encoding utf-8

=head1 NAME

CPAN::Flatten - flatten cpan module requirements without install

=head1 SYNOPSIS

  $ perl -Ilib script/flatten Moo
  -> Searching distribution for Moo, found Moo-2.000001
    -> Searching distribution for Module::Runtime, found Module-Runtime-0.014
      -> Searching distribution for Module::Build, found Module-Build-0.4214
    -> Searching distribution for Class::Method::Modifiers, found Class-Method-Modifiers-2.11
    -> Searching distribution for Devel::GlobalDestruction, found Devel-GlobalDestruction-0.13
      -> Searching distribution for Sub::Exporter::Progressive, found Sub-Exporter-Progressive-0.001011
    -> Searching distribution for Role::Tiny, found Role-Tiny-2.000001

  H/HA/HAARG/Moo-2.000001.tar.gz
    runtime_requires
      Z/ZE/ZEFRAM/Module-Runtime-0.014.tar.gz
      E/ET/ETHER/Class-Method-Modifiers-2.11.tar.gz
      H/HA/HAARG/Devel-GlobalDestruction-0.13.tar.gz
      H/HA/HAARG/Role-Tiny-2.000001.tar.gz
  Z/ZE/ZEFRAM/Module-Runtime-0.014.tar.gz
    configure_requires
      L/LE/LEONT/Module-Build-0.4214.tar.gz
    build_requires
      L/LE/LEONT/Module-Build-0.4214.tar.gz
  L/LE/LEONT/Module-Build-0.4214.tar.gz
  E/ET/ETHER/Class-Method-Modifiers-2.11.tar.gz
  H/HA/HAARG/Devel-GlobalDestruction-0.13.tar.gz
    runtime_requires
      F/FR/FREW/Sub-Exporter-Progressive-0.001011.tar.gz
  F/FR/FREW/Sub-Exporter-Progressive-0.001011.tar.gz
  H/HA/HAARG/Role-Tiny-2.000001.tar.gz

=head1 DESCRIPTION

This is experimental.

CPAN::Flatten flattens cpan module requirements without install.

As you know, the cpan world allows cpan modules to configure themselves dynamically.
So actual requirements can not be determined
unless you install them to your local machines.

But, I think dynamic configuration is generally harmful,
and we should avoid that.

So what happens if we flattens cpan module requirements without install?

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2015- Shoichi Kaji

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
