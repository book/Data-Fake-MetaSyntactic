package Data::Fake::MetaSyntactic;

use strict;
use warnings;
use Exporter 5.57 qw( import );

our @EXPORT = qw( fake_meta fake_metatheme fake_metacategory );

use Acme::MetaSyntactic ();
my @themes = grep $_ ne 'any', Acme::MetaSyntactic->themes;

sub fake_meta {
    my ($theme) = @_;
    $theme ||= fake_metatheme()->();

    my $meta = Acme::MetaSyntactic->new;
    return sub {
        $meta->name( ref $theme eq 'CODE' ? $theme->() : $theme );
    };
}

sub fake_metatheme {
    return sub { $themes[ rand @themes ] };
}

sub fake_metacategory {
    my ($theme) = @_;
    $theme ||= fake_metatheme()->();

    return ref $theme eq 'CODE'
        ? sub {
            my @categories = _categories( $theme->() );
            $categories[ rand @categories ];
        }
        : do {
            my @categories = _categories($theme);
            sub { $categories[ rand @categories ] };
        };
}

sub _categories {
    my ($theme) = @_;
    require "Acme/MetaSyntactic/$theme.pm";
    return (
        $theme => map "$theme/$_",
        eval { "Acme::MetaSyntactic::$theme"->categories }
    );
}

1;

__END__

=head1 NAME

Data::Fake::MetaSyntactic - Fake metasyntactic data generators
 
=head1 SYNOPSIS
 
    use Data::Fake::MetaSyntactic;

    fake_metatheme()->();   # foo, donmartin, weekdays, etc.
    fake_meta()->();        # titi, GING_GOYNG, wednesday, etc.
 
=head1 DESCRIPTION
 
This module provides fake data generators for L<Acme::MetaSyntactic>.
 
All functions are exported by default.
 
=head1 FUNCTIONS
 
=head2 fake_meta
 
    $generator = fake_name( $theme );
 
Returns a generator that provides a randomly selected item from the
given L<Acme::MetaSyntactic> theme.

The theme name can be given in the form C<theme/category> if the correspnding
L<Acme::MetaSyntactic> theme supports categories.

C<$theme> can be a code reference that returns a theme name when executed.

If no C<$theme> is given, a random theme is picked among the installed
ones.

=head2 fake_metatheme
 
    $generator = fake_metatheme();
 
Returns a generator that provides a random L<Acme::MetaSyntactic> theme name,
among the installed ones.

=head1 EXAMPLES

=over 4

=item *

Generate a random item from a given theme

    $generator = fake_meta( $theme );

=item *

Generate a random item from a randomly selected theme

    $generator = fake_meta();

=item *

Generate a random item from a different random theme each time

    $generator = fake_meta( fake_metatheme() );

=back

=head1 SEE ALSO

L<Data::Fake>, L<Acme::MetaSyntactic>, L<Task::MetaSyntactic>.

=head1 AUTHOR
 
Philippe Bruhat (BooK), <book@cpan.org>.
 
=head1 COPYRIGHT

Copyright 2015 Philippe Bruhat (BooK), all rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
