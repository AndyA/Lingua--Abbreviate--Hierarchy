#!perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Differences;
use Data::Dumper;
use Lingua::Abbreviate::Hierarchy;

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

sub newlah {
  ok my $lah = Lingua::Abbreviate::Hierarchy->new( @_ ), 'new';
  isa_ok $lah, 'Lingua::Abbreviate::Hierarchy';
  $lah->add_namespace( @ns );
  return $lah;
}

{
  my $lah = newlah();
  eq_or_diff [ $lah->ab( @ns ) ], [
    qw(
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
     )
   ],
   'abbr - no limits';
}

{
  my $lah = newlah( only => 2 );
  eq_or_diff [ $lah->ab( @ns ) ], [
    qw(
     c.l.perl.misc
     c.l.perl.advocacy
     c.l.perl.mod_perl
     c.l.forth
     c.l.basic
     c.l.basic.bbc
     c.l.bcpl
     c.l.python
     c.l.python.misc
     c.l.cobol
     c.l.c
     )
   ],
   'abbr - only 2';
}

{
  my $lah = newlah( keep => 2 );
  eq_or_diff [ $lah->ab( @ns ) ], [
    qw(
     c.l.perl.misc
     c.l.perl.advocacy
     c.l.perl.mod_perl
     c.lang.forth
     c.lang.basic
     c.l.basic.bbc
     c.lang.bcpl
     c.lang.python
     c.l.python.misc
     c.lang.cobol
     c.lang.c
     )
   ],
   'abbr - keep 2';
}

# vim:ts=2:sw=2:et:ft=perl

