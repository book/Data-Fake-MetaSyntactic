package Data::Fake::MetaSyntactic;

use strict;
use warnings;
use Exporter 5.57 qw( import );

our @EXPORT = qw( fake_meta fake_metatheme );

use Acme::MetaSyntactic ();
my @themes = grep $_ ne 'any', Acme::MetaSyntactic->themes;

sub fake_meta {
    my ($theme) = @_;
    $theme ||= $themes[ rand @themes ];

    my $meta = Acme::MetaSyntactic->new;
    return sub {
        $meta->name( ref $theme eq 'CODE' ? $theme->() : $theme );
    };
}

sub fake_metatheme {
    return sub { $themes[ rand @themes ] };
}

1;

