package Clouseau;

use 5.008003;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Acme::Clouseau ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(clouseau);

our $VERSION = '0.02';

sub clouseau {

  my( $message ) = @_;
  
  $message =~ s/\b(\w+)ed\b/$1-ed/g;

  # The closed o and ooh-la-la should be pronounced -eu
  $message =~ s/\b(\w+)(or|our|ore|er)\b/$1eur/g;
  $message =~ s/\b(\w+)(ors|ours|ores|ers)\b/$1eurs/g;
  $message =~ s/\b(\w+)o\b/$1eu/g;
  $message =~ s/\b(\w+)ow\b/$1euw/g;

  # Ay becomes Ah, as in crazy becomes crah-zee

  $message =~ s/\b(\w)ra(\w+)\b/$1rah$2/g;
  
  return( $message );
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Acme::Clouseau - Perl extension clouseau-i-fying text!

=head1 SYNOPSIS

  use Acme::Clouseau;
  print clouseau("file.txt");

=head1 DESCRIPTION

Want to see how your documents read if uttered by Chief Inspector Jacques Clouseau?
Acme::Clouseau is for you!!

=head2 EXPORT

clouseau(), transform otherwise boring prose into Clouseau-esque diatribes.

=head1 AUTHOR

Martin-Louis Bright, mlbright@gmail.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Martin-Louis Bright

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.

=cut
