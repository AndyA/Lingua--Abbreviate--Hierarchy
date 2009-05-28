use strict;
use warnings;
use Module::Build;

use lib 'inc';

use MyBuilder;

my $builder = MyBuilder->new(
  module_name       => 'Lingua::Abbreviate::Hierarchy',
  license           => 'perl',
  dist_author       => 'Andy Armstrong <andy@hexten.net>',
  dist_version_from => 'lib/Lingua/Abbreviate/Hierarchy.pm',
  requires          => { 'Test::More' => 0, },
  add_to_cleanup    => ['Lingua-Abbreviate-Hierarchy-*'],
);

$builder->create_build_script();
