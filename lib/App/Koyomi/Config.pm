package App::Koyomi::Config;

use strict;
use warnings;
use 5.010_001;
use File::Spec;
use Perl6::Slurp;
use TOML qw(from_toml);

use version; our $VERSION = 'v0.1.0';

my $CONFIG;

sub instance {
    my $class = shift;
    $CONFIG //= sub {
        my $toml = slurp( _config_path() );
        my ($data, $err) = from_toml($toml);
        unless ($data) {
            die "Error parsing toml: $err";
        }
        return bless $data, $class;
    }->();
    return $CONFIG;
}

sub _config_path {
    my $path;
    if ($ENV{KOYOMI_CONFIG_PATH}) {
        $path = $ENV{KOYOMI_CONFIG_PATH};
    }
    $path ||= File::Spec->catfile('config', 'default.toml');
    if (! -r $path) {
        die "Can't read $path";
    }
    return $path;
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Config> - koyomi config

=head1 SYNOPSIS

    use App::Koyomi::Config;
    my $config = App::Koyomi::Config->instance;

=head1 DESCRIPTION

This module represents Singleton config object.

=head1 METHODS

=over 4

=item B<instance>

Fetch schedule singleton.

=back

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

