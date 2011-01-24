###############################################################################
#
#  This module is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  Trigger
#  Copyright (C) 2003-2004 Deep Gorge Technologies
#
###############################################################################

#================================================
package Trigger::Trigger;
#================================================

use strict;

use LWP::Simple;

my $VERSION = 'Trigger .1 (2004.01.15)';
my $DATAVERSION = 'Trigger Data .1';


#================================================
# Constructor
#================================================

sub new
{
	my $class = shift;
	my %options = @_;

	my $this =
	{
		'debug'					=> $options{'debug'} || 0,
		'filename'				=> $options{'filename'} || "./direct_responses.txt",
		'direct_responses'	=> []
	};
	bless $this, $class;

	$this->loadResponses();

	print( $VERSION . "\n" );

	return $this;
}

#================================================
# Destructor
#================================================

sub DESTROY
{
	my $this = shift;

}

#================================================
# Get the version of this module
#================================================

sub getVersion
{
	my $this = shift;
	return $VERSION;
}

#================================================
# AUTOLOAD method to handle all unknown method calls
#================================================

sub AUTOLOAD
{
	my $this = shift;

	print( "method $Trigger::AUTOLOAD not defined\n" );
}

sub debug
{
	my $this = shift;
	my $string = shift;

	print( "$string\n" ) if( $this->{'debug'} );
}

#================================================
# Setup methods
#================================================

sub setDebug
{
	my $this = shift;
	my $debug = shift || 0;

	$this->{'debug'} = $debug;
}

sub setFilename
{
	my $this = shift;
	my $filename = shift || "./direct_responses.txt";

	$this->{'filename'} = $filename;
}

#================================================
# Content methods
#================================================

sub loadResponses
{
	my $this = shift;

	open( FILE, $this->{'filename'} ) || die( "Unable to load response file\n" );
	my @lines = <FILE>;
	close( FILE );

	chomp @lines;

   # remove the data version line, do nothing with it at the moment
	my $data_version = shift;

	$this->{'direct_responses'} = \@lines;
}

#================================================
# Process methods
#================================================

sub transform
{
	my $this = shift;
	my( $teacher, $message ) = @_;

	return '' if( $message eq '' );

	foreach my $line (@{$this->{'direct_responses'}})
	{
		next if( $line eq '' );

		my ($first, $last) = split( /###/, $line );
		if( $message =~ /$first/i )
		{
			if( $last =~ /^service:(.*)$/i )
			{
				my $service_string = $1;
				$service_string =~ s/##MESSAGE##/$message/g;

				return LWP::Simple::get( $service_string );
			}
			else
			{
				my @last = split( /\|/, $last );
				return $last [ int rand scalar @last ];
			}
		}
	}

	return '';
}


1;
