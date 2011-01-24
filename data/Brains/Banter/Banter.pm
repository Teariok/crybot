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
#  Banter
#  Copyright (C) 2003-2004 Deep Gorge Technologies
#
###############################################################################

#================================================
package Banter::Banter;
#================================================

use strict;

my $VERSION = 'Banter .1 (2004.03.14)';

my $DATADIR = './data/Brains/Banter/banterdata';


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
		'ucfirst'				=> $options{'ucfirst'} || 1,
		'fixan'					=> $options{'fixan'} || 1,
		'sentences'				=> {},
		'words'					=> {}
	};
	bless $this, $class;

	print( $VERSION . "\n" );

	$this->loadData();

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

	print( "method $Banter::AUTOLOAD not defined\n" );
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

#================================================
# Content methods
#================================================

sub loadData
{
	my $this = shift;

	my $type = '';

	opendir( DIR, "$DATADIR/sentences/" ) || ( print( "Banter ERROR: coundn't open dir $DATADIR/sentences/\n" ) && return );
	foreach my $file (sort( grep( !/^\./, readdir( DIR ) ) ) )
	{
		my $name = uc $file;
		$name =~ s/\..+$//g;

		$this->debug( "Banter: loading sentences from $DATADIR/sentences/$file" );
		open( FILE, "$DATADIR/sentences/$file" ) || ( print( "Banter ERROR: couldn't open file $DATADIR/sentences/$file\n" ) && next );
		my @lines = <FILE>;
		close( FILE );
		chomp @lines;

		foreach my $line (@lines)
		{
			# skip empty lines and comment lines
			next if( $line eq '' || $line =~ /^\s*#/ );

			if( $line =~ /type=(\w+)/i )
			{
				$type = uc $1;
			}
			elsif( $type ne '' )
			{
				push( @{$this->{'sentences'}->{$type}}, $line );
			}
		}
	}
	closedir( DIR );

	opendir( DIR, "$DATADIR/words/" ) || ( print( "Banter ERROR: coundn't open dir $DATADIR/words/\n" ) && return );
	foreach my $file (sort( grep( !/^\./, readdir( DIR ) ) ) )
	{
		print( "Banter: loading words from $DATADIR/words/$file\n" );
		open( FILE, "$DATADIR/words/$file" ) || ( print( "Banter ERROR: couldn't open file $DATADIR/words/$file\n" ) && next );
		my @lines = <FILE>;
		close( FILE );
		chomp @lines;

		foreach my $line (@lines)
		{
			# skip empty lines and comment lines
			next if( $line eq '' || $line =~ /^\s*#/ );

			if( $line =~ /type=(\w+)/i )
			{
				$type = uc $1;
			}
			elsif( $type ne '' )
			{
				push( @{$this->{'words'}->{$type}}, $line );
			}
		}
	}
	closedir( DIR );
}

#================================================
# Get a randomly generated sentence
#================================================

sub transform
{
	my $this = shift;
	my $type = shift || 'MAIN';

	# all of our types are full caps keys
	$type = uc $type;

	# default to MAIN if type is not found
	$type = 'MAIN' if( !defined $this->{'sentences'}->{$type} );

	# return an empty response if our type is still not found
	return '' if( !defined $this->{'sentences'}->{$type} );

	my $total_sentences = scalar @{$this->{'sentences'}->{$type}};

	# return an empty response if there are no sentences for this type
	return '' if( $total_sentences == 0 );

	$this->debug( "Banter: randomly choosing from $total_sentences $type sentences" );

	my $rand_sent = int rand $total_sentences;
	my $response = $this->{'sentences'}->{$type}->[$rand_sent];

	while( $response =~ /\*(\w+?)\*/g )
	{
		my $word_replace = $1;
		my $word_type = uc $1;

		if( defined $this->{'words'}->{$word_type} )
		{
			my $total_words = scalar @{$this->{'words'}->{$word_type}};
			if( $total_words == 0 )		{ $response =~ s/\*$word_replace\*/-/; }
			else								{ $response =~ s/\*$word_replace\*/$this->{'words'}->{$word_type}->[int rand $total_words]/; }
		}
		else
		{
			$response =~ s/\*$word_replace\*/-/;
		}
	}

	$response =~ s/a\s+(a|e|i|o|u)/an $1/gi if( $this->{'fixan'} == 1 );
	$response = ucfirst $response if( $this->{'ucfirst'} == 1 );

	return $response;
}


1;
