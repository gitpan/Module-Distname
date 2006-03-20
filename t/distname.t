#!perl
use strict;
use warnings;

use Data::Dumper;
use Test::More;

use Module::Distname;

# Some of these are not widely available; we include 
# them anyway, on the off chance we have them. 
my %tests = (
  'Apache::Request' => 'libapreq',
  'HTTP::Request::Common' => 'libwww-perl',
  'Apache::Constants' => 'mod_perl',
  'Test::More' => 'Perl',
  'ExtUtils::Installed' => 'Perl',
  'Test::Exception' => 'Test::Exception',
);

plan tests => 1 + scalar keys %tests;

my %dists;
for (keys %tests) {
  SKIP: {
    eval "use $_ ()";
    skip "Could not find $_ in \@INC", 1 
      if $@ =~ m{Can't locate .*\.pm in \@INC};

    %dists = Module::Distname->dists( $_ );
    skip "Couldn't find dist containing $_; does your system have packlists?", 1
      unless keys %dists;

    ok( exists $dists{$tests{$_}}, "$_ found in $tests{$_}")
      or diag Dumper \%dists;
  }
}

eval { Module::Distname->dists( 'Not::A::Real::Module' ) };
ok( $@ =~ /Can't find 'Not::A::Real::Module'/, "cannot find non-existing module" );

