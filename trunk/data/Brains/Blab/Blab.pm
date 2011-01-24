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
#  Blab
#  Copyright (C) 2003 Deep Gorge Technologies
#
###############################################################################

#================================================
package Blab::Blab;
#================================================

use strict;

my $VERSION = 'Blab .1 (2003.12.27)';


#================================================
# Constructor
#================================================

sub new
{
	my $class = shift;

	my $this =
	{
		'sent'					=> {},
		'linked_responses'	=> {},
		'all_responses'		=> {}
	};
	bless $this, $class;

	$this->loadResponses();

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

	print( "method $Blab::AUTOLOAD not defined\n" );
}

#================================================
# Main methods
#================================================

sub loadResponses
{
	my $this = shift;

	open( FILE, "./linked_responses.txt" ) || return;
	my @lines = <FILE>;
	close( FILE );

	chomp @lines;

	foreach my $line (@lines)
	{
		my( $input, $output, $number ) = split( /###/, $line );

		$this->{'linked_responses'}->{$input} = {} if( !defined $this->{'linked_responses'}->{$input} );
		$this->{'linked_responses'}->{$input}->{$output} += $number;

		$this->{'all_responses'}->{$output}++;
	}
}

sub transform
{
	my $this = shift;

	my( $sender, $message ) = @_;

	my $response = '';

   # only add a link if we already sent the user a message
	if( defined $this->{'sent'}->{$sender} )
	{
		$this->addResponse( $this->{'sent'}->{$sender}, $message );
	}

   # main decision code
   # uses rand to create a little more variety in the responses

	if( int rand 5 < 4 )
	{
		$response = $this->getExactResponse( $message );
#		print( "using exact\n" ) if( $response ne '' );
	}

	if( $response eq '' && int rand 5 < 4 )
	{
		$response = $this->getSearchExactResponse( $message );
#		print( "using search exact\n" ) if( $response ne '' );
	}

	my $split = int rand 9;

	if( $response eq '' && $split < 2 )
	{
		$response = $this->getInputSearchResponse( $message );
#		print( "using input search\n" ) if( $response ne '' );
	}

	if( $response eq '' && $split < 6 )
	{
		$response = $this->getSearchResponse( $message );
#		print( "using search\n" ) if( $response ne '' );
	}

	if( $response eq '' )
	{
		$response = $this->getRandomResponse( );
#		print( "using random\n" ) if( $response ne '' );
	}

	if( $response eq '' )
	{
		$response = 'hi';
#		print( "using default\n" );
	}

## code to introduce a small typo (for realistic effect)
#	if( length $response > 10 && int rand 10 < 3 )
#	{
#		$response =~ s/ (.)/$1 /;
#	}

	$this->{'sent'}->{$sender} = $response;

	return $response;
}

sub addResponse
{
	my $this = shift;

	my( $input, $output ) = @_;

#	print( "addResponse( $input, $output )\n" );

	$this->{'linked_responses'}->{$input} = {} if( !defined $this->{'linked_responses'}->{$input} );
	$this->{'linked_responses'}->{$input}->{$output}++;

	$this->{'all_responses'}->{$output} = 0 if( !defined $this->{'all_responses'}->{$output} );
	$this->{'all_responses'}->{$output}++;

	open( FILE, ">>./linked_responses.txt" );
	print( FILE "$input###$output###1\n" );
	close( FILE );
}

sub getExactResponse
{
	my $this = shift;

	my $input = shift;

	foreach my $key (keys %{$this->{'linked_responses'}})
	{
		if( lc $key eq lc $input )
		{
			my @keys = keys %{$this->{'linked_responses'}->{$key}};

			my $total = scalar @keys;

			if( $total > 0 )
			{
				return $keys[int rand $total];
			}
		}
	}

	return '';
}

sub getSearchExactResponse
{
	my $this = shift;

	my $input = shift;

	my $input1 = $this->cleanInput( $input );
	my @words = split( /\s+/, $input1 );

	my @possible = ();

	foreach my $word (@words)
	{
		foreach my $key (keys %{$this->{'linked_responses'}})
		{
			if( lc $key ne lc $input && $key =~ /\b$word\b/gi )
			{
				push( @possible, $key );
			}
		}
	}

	my $total = scalar @possible;

	if( $total > 0 )
	{
		my $key = $possible[int rand $total];

		my @keys = keys %{$this->{'linked_responses'}->{$key}};

		my $total1 = scalar @keys;

		if( $total1 > 0 )
		{
			return $keys[int rand $total1];
		}
	}

	return '';
}

sub getInputSearchResponse
{
	my $this = shift;

	my $input = shift;

	my $input1 = $this->cleanInput( $input );
	my @words = split( /\s+/, $input1 );

	my @possible = ();

	foreach my $word (@words)
	{
		foreach my $key (keys %{$this->{'linked_responses'}})
		{
			if( lc $key ne lc $input && $key =~ /\b$word\b/gi )
			{
				push( @possible, $key );
			}
		}
	}

	my $total = scalar @possible;

	if( $total > 0 )
	{
		return $possible[int rand $total];
	}

	return '';
}

sub getSearchResponse
{
	my $this = shift;

	my $input = shift;

	my $input1 = $this->cleanInput( $input );
	my @words = split( /\s+/, $input1 );

	my @possible = ();

	foreach my $word (@words)
	{
		foreach my $key (keys %{$this->{'all_responses'}})
		{
			if( lc $key ne lc $input && $key =~ /\b$word\b/gi )
			{
				push( @possible, $key );
			}
		}
	}

	my $total = scalar @possible;

	if( $total > 0 )
	{
		return $possible[int rand $total];
	}

	return '';
}

sub getRandomResponse
{
	my $this = shift;

	my @keys = keys %{$this->{'all_responses'}};

	my $total = scalar @keys;

	if( $total > 0 )
	{
		return $keys[int rand $total];
	}

	return '';
}


# function to remove common words and punctuation so that the keyword searches above are more meaningful
sub cleanInput
{
	my $this = shift;

	my $message = shift;

	$message =~ s/n\'t/ not/gi;
	$message =~ s/\'re/ are/gi;
	$message =~ s/\'m/ am/gi;
	$message =~ s/\'s/ is/gi;

	$message =~ s/\b(the|a|an|there|that|this|it)\b//gi;
	$message =~ s/\b(am|is|are|be|was|were)\b//gi;
	$message =~ s/\b(you|me|i|my|mine)\b//gi;
	$message =~ s/\b(can|will|may|could|would|might|should)\b//gi;
	$message =~ s/\b(part|type|kind)\b//gi;
	$message =~ s/\b(of|for|in|out|on|over|under|at|near|by|to|from|with|up|down)\b//gi;
	$message =~ s/\b(and|but|or|not)\b//gi;
	$message =~ s/\b(has|have|had|make|makes|made|do|does|did|find|finds|found|use|uses|used|go|goes|went)\b//gi;
	$message =~ s/\b(yes|no|yea|yeah|ok)\b//gi;
	$message =~ s/\b(what|where|who|why|when|how)\b//gi;
	$message =~ s/\b(too|also|very|much|more|many|some|most)\b//gi;

	$message =~ s/(\.|\?|\!|\,|\;|\:|\"|\'|\(|\)|\/|\\|\*|\%|\+|\-)//gi;
	$message =~ s/\d+//gi;

	$message =~ s/^\s+//g;
	$message =~ s/\s+$//g;
	$message =~ s/\s+/ /g;

	return $message;
}


1;
