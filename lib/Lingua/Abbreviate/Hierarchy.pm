package Lingua::Abbreviate::Hierarchy;

use warnings;
use strict;

use Carp qw( croak );
use List::Util qw( min max );

=head1 NAME

Lingua::Abbreviate::Hierarchy - Shorten verbose namespaces

=head1 VERSION

This document describes Lingua::Abbreviate::Hierarchy version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

  use Lingua::Abbreviate::Hierarchy;
  
=head1 DESCRIPTION

=head1 INTERFACE 

=head2 C<< new >>

=cut

{
  my %DEFAULT = (
    sep   => '.',
    only  => undef,
    keep  => undef,
    max   => undef,
    trunc => undef,
  );

  sub new {
    my ( $class, %options ) = @_;

    my @unk = grep { !exists $DEFAULT{$_} } keys %options;
    croak "Unknown option(s): ", join ', ', sort @unk if @unk;
    my $self = bless { %DEFAULT, %options, _ns => {} }, $class;
    $self->{join} = $self->{sep} unless exists $self->{join};
    return $self;
  }
}

=head2 C<< add_namespace >>

=cut

sub add_namespace {
  my $self = shift;
  croak "Can't add to namespace after calling ab()"
   if $self->{_cache};
  my $sepp = quotemeta $self->{sep};
  for my $term ( map { 'ARRAY' eq ref $_ ? @$_ : $_ } @_ ) {
    my @path = split /$sepp/o, $term;
    $self->{_ns} = $self->_add_node( $self->{_ns}, @path );
  }
}

sub _add_node {
  my ( $self, $nd, $wd, @path ) = @_;
  $nd ||= {};
  $nd->{$wd} ||= {};
  if ( @path ) {
    $nd->{$wd}{k} = $self->_add_node( $nd->{$wd}{k}, @path );
  }
  else {
    $nd->{$wd}{t} = 1;
  }
  return $nd;
}

=head2 C<< ab >>

=cut

sub ab {
  my $self = shift;
  $self->_init unless $self->{_cache};
  my @ab = map { $self->{_cache}{$_} ||= $self->_abb( $_ ) } @_;
  return wantarray ? @ab : $ab[0];
}

sub _abb {
  my ( $self, $term ) = @_;

  my $sepp = quotemeta $self->{sep};
  my @path = split /$sepp/, $term;

  if ( defined( my $max = $self->{max} ) ) {
    my $from = $self->{only} || 0;
    my $to = scalar( @path ) - ( $self->{keep} || 0 );
    my $ab = $term;
    for my $cnt ( $from .. $to ) {
      $ab = join $self->{join}, $self->_ab( $self->{_ns}, $cnt, @path );
      return $ab if length $ab <= $max;
    }
    if ( defined( my $trunc = $self->{trunc} ) ) {
      return substr $trunc, 0, $max if length $trunc > $max;
      return $trunc . substr $ab, 0, $max - length $trunc;
    }
    return $ab;
  }
  else {
    my $lt = scalar @path;
    $lt = max( $lt - $self->{keep}, 0 ) if defined $self->{keep};
    $lt = min( $lt, $self->{only} ) if defined $self->{only};
    return join $self->{join}, $self->_ab( $self->{_ns}, $lt, @path );
  }
}

sub _ab {
  my ( $self, $nd, $limit, $word, @path ) = @_;
  return $word, @path if $limit-- <= 0;
  return $word, @path unless $nd && $nd->{$word};
  return ( $nd->{$word}{a},
    @path ? $self->_ab( $nd->{$word}{k}, $limit, @path ) : () );
}

sub _init {
  my $self = shift;
  $self->_make_ab( $self->{_ns} );
  $self->{_cache} = {};
}

sub _ab_list {
  my ( $self, @w ) = @_;

  my %a   = ();
  my $len = 1;
  my @bad = @w;

  while () {
    $a{$_} = $len < length $_ ? substr $_, 0, $len : $_ for @bad;
    $len++;
    my %cc = ();
    $cc{ $a{$_} }++ for keys %a;
    @bad = grep { $cc{ $a{$_} } > 1 } keys %a;
    return \%a unless @bad;
  }
}

sub _make_ab {
  my ( $self, $nd ) = @_;
  my @kk = keys %$nd;
  my $ab = $self->_ab_list( @kk );
  for my $k ( @kk ) {
    $nd->{$k}{a} = $ab->{$k};
    $self->_make_ab( $nd->{$k}{k} ) if $nd->{$k}{k};
  }

}

"Ceci n'est pas 'Modern Perl'";

__END__

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-lingua-abbreviate-hierarchy@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Andy Armstrong  C<< <andy@hexten.net> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, Andy Armstrong C<< <andy@hexten.net> >>.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
