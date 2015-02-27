package Data::Fake::MetaSyntactic;

use strict;
use warnings;
use Exporter 5.57 qw( import );

our @EXPORT = qw( fake_meta fake_metatheme );

use Acme::MetaSyntactic;
my @themes = grep $_ ne 'any', Acme::MetaSyntactic->themes;

sub fake_meta {
    my ( $theme, $count ) = @_;
    $theme ||= $themes[ rand @themes ];
    $count ||= 1;

    my $meta = Acme::MetaSyntactic->new;
    return sub {
        $meta->name(
            ref $theme eq 'CODE' ? $theme->() : $theme,
            ref $count eq 'CODE' ? $count->() : $count,
        );
    };
}

sub fake_metatheme {
    return sub { $themes[ rand @themes ] };
}

1;

