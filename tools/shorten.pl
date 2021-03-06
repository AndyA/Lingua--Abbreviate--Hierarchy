#!/usr/bin/env perl

use strict;
use warnings;

use lib qw( lib );

use File::Spec;
use Lingua::Abbreviate::Hierarchy;

my $meta = meta();
my $abr = Lingua::Abbreviate::Hierarchy->new( sep => '::' );
$abr->add_namespace( ref $abr, keys %{ $meta->{m} } );
print $abr->ab( ref $abr ), "\n";

{
  my $Meta;

  sub meta {
    $Meta ||= read_meta(
      File::Spec->catfile(
        (
          find_dot_cpan()
           or die "Can't find your .cpan directory\n"
        ),
        'sources',
        'modules',
        '02packages.details.txt.gz'
      )
    );
  }
}

sub read_meta {
  my $details    = shift;
  my $by_module  = {};
  my $by_package = {};

  read_packages(
    $details,
    sub {
      my ( $mod, $ver, $dist ) = @_;
      $by_module->{$mod} = [ $ver, $dist ];
      $by_package->{$dist}{$mod} = $ver;
    }
  );
  return {
    m => $by_module,
    p => $by_package,
  };
}

sub read_packages {
  my ( $details, $cb ) = @_;
  -e $details or die "$details not found\n";
  open my $dh, '-|', 'gzip', '-cd', $details
   or die "Can't expand $details\n";
  while ( <$dh> ) {
    chomp;
    if ( /^\s*$/ .. 0 ) {
      next if /^\s*$/;
      my ( $mod, $ver, $dist ) = split /\s+/;
      $cb->( $mod, $ver, $dist );
    }
  }
}

sub find_dot_cpan { glob '~/.cpan' }

# vim:ts=2:sw=2:sts=2:et:ft=perl

