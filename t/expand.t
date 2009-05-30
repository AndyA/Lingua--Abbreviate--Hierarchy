#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::Differences;
use Data::Dumper;
use Lingua::Ab::H;

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

my @ab = qw(
 c.l.pe.mi
 c.l.pe.a
 c.l.pe.mo
 c.l.f
 c.l.ba
 c.l.ba.b
 c.l.bc
 c.l.py
 c.l.py.m
 c.l.co
 c.l.c
);

my $lah = Lingua::Ab::H->new( @_, ns => \@ns );
my @got = $lah->ab( @ns );
eq_or_diff [@got], [@ab], 'abbreviate';
my @ex = $lah->ex(@got);
eq_or_diff [@ex], [@ns], 'expand';

# vim:ts=2:sw=2:et:ft=perl

