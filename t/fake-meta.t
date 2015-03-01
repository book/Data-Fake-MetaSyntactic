use strict;
use warnings;
use Test::More;

use Data::Fake::MetaSyntactic;

use Acme::MetaSyntactic;
use List::Util qw( min );

my $count = 5;

plan tests => 2 + $count * ( $count + 1 );

my %theme;
@theme{ grep $_ ne 'any', Acme::MetaSyntactic->themes } = ();
diag scalar keys %theme, " Acme::MetaSyntactic themes installed";

# fake_metatheme
for my $args ( [], [ 'foo' ] ) {
    my $metacategory = fake_metacategory( @$args );
    is( ref $metacategory, 'CODE', "fake_metatheme() returns a coderef" );
}

my $metatheme = fake_metatheme;
for ( 1 .. $count ) {

    my $theme = $metatheme->();
    ok( exists $theme{$theme}, "$theme is an installed theme" );

    my %item;
    @item{ Acme::MetaSyntactic->new($theme)->name(0) } = ();

    for ( 1 .. $count ) {
        my $item = fake_meta($theme)->();
        ok( exists $item{$item}, "$item is an item from $theme" );
    }
}

done_testing;
