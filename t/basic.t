#!perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Differences;
use Data::Dumper;
use Lingua::Abbreviate::Hierarchy;

ok my $lah = Lingua::Abbreviate::Hierarchy->new, 'new';
isa_ok $lah, 'Lingua::Abbreviate::Hierarchy';
my @ns = qw(
 comp.lang.perl.misc
 comp.lang.perl.advocacy
 comp.lang.perl.mod_perl
 comp.lang.forth
 comp.lang.basic
 comp.lang.basic.bbc
 comp.lang.bcpl
 comp.lang.python
 comp.lang.python.misc
 comp.lang.cobol
 comp.lang.c
);
$lah->add_namespace( @ns );

eq_or_diff [ $lah->ab( @ns ) ], [], 'ab 1';
#diag Dumper( $lah );

# vim:ts=2:sw=2:et:ft=perl

