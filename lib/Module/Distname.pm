package Module::Distname;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp;
use ExtUtils::Installed;

=head1 NAME

Module::Distname - find out which dist (or dists) a module lives in

=head1 SYNOPSIS

  use Module::Distname;
  my @dists = Module::Distname->dists('Test::More');
  print join(', ', @dists), "\n";

=head1 DESCRIPTION

This module works by searching the F<.packlist> files installed by
L<Module::Build> and L<ExtUtils::MakeMaker> and attempt to figure out the dist
names from the file paths.

=head1 METHODS

=over

=item dists( module_name )

Returns a hash of 'dist name' => 'version' mappings of all the
currently-installed dists that contain the given module. Usually
this would be a one-element hash. However, if the module is core
it will also be in the 'Perl' dist. If a version cannot be
determined, an empty string will be in its place.

This method will croak if it cannot load the given module.

=cut


{
  my ($extutils, @dists);

  sub _extutils {
    $extutils ||= ExtUtils::Installed->new;
  }

  sub _dists {
    @dists = _extutils()->modules unless @dists;
    @dists;
  }
}

sub dists {
  my $self = shift;
  my $module = shift;
  
  eval "use $module ()";
  croak "Can't find '$module': $@" if $@;
    
  my $key = join('/', split(/::/, $module)) . '.pm';
  my $file = $INC{$key};
  
  my %dists;
  for (_dists()) {
    if (grep { /$file/ } _extutils()->files($_, "prog")) {
      $dists{$_} = _extutils()->version($_);
    }
  }

  return %dists;
}

1;

=back

=head1 BUGS

=over

=item

This module relies on F<.packlist>s and B<will not work> if these
are not present.

=item

It can be argued that the functionality of this module should be rolled into 
L<ExtUtils::Installed>.

=back

Please report any bugs you find via the CPAN RT system. 
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Distname>

=head1 AUTHOR

Stig Brautaset <stig@brautaset.org>

You can reach the current maintainers by emailing us at cpan@fotango.com, but
if you're reporting bugs please use the RT system mentioned above so we can
track the issues you report.

=head1 SEE ALSO

L<Module::Build>, L<ExtUtils::MakeMaker>, L<ExtUtils::Packlist>

=head1 COPYRIGHT

Copyright Fotango 2006. All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
