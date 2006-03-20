#!perl
use strict;
use warnings;
use Module::Build;
Module::Build->new(
  license => 'perl',
  module_name => 'Module::Distname',
  requires => {
    'perl' => '5.8.1',
  },
  build_requires => {
    'Test::More' => 0,
  },
  create_readme => 1,
  create_makefile_pl => 'traditional',
)->create_build_script;
  
