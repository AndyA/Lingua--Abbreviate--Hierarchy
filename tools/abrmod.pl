#!/usr/bin/env perl

use strict;
use warnings;

use lib qw( lib );

use File::Find;
use File::Spec;
use Lingua::Ab::H;
use List::Util qw( max );

my @names = ();
if ( @ARGV ) {
  for my $dir ( @ARGV ) {
    find(
      {
        no_chdir => 1,
        wanted   => sub {
          return unless /\.pm$/;
          ( my $n
             = File::Spec->abs2rel( File::Spec->rel2abs( $_ ), $dir ) )
           =~ s!/!::!g;
          $n =~ s/\.pm$//;
          push @names, $n;
        },
      },
      $dir
    );
  }
}
else {
  chomp( @names = <> );
}

my $abr = Lingua::Ab::H->new( keep => 1, sep => '::', ns => \@names );
my $len = max map { length $_ } @names;
for my $n ( sort @names ) {
  printf "%-${len}s %s\n", $n, $abr->ab( $n );
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

