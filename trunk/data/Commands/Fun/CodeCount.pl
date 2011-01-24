sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	my $codelines;
	my @lines;

	open( BOT, './crybot.pl' );
		@lines = <BOT>;
	close( BOT );

	$codelines->{'bot'} = int( scalar( @lines ) );
	$codelines->{'total'} = $codelines->{'bot'};

	open( CONFIG, './data/Bots/crybot.xml' );
		@lines = <CONFIG>;
	close( CONFIG );

	$codelines->{'config'} = int( scalar( @lines ) );
	$codelines{'total'} += $codelines->{'config'};

	open( LIB, './data/lib/MSN.pm' );
		@lines = <LIB>;
	close( LIB );

	$codelines->{'lib'} = int( scalar( @lines ) );

	open( LIB, './data/lib/Timer.pm' );
		@lines = <LIB>;
	close( LIB );

	$codelines->{'lib'} += int( scalar( @lines ) );

	open( LIB, './data/lib/MSN/SwitchBoard.pm' );
		@lines = <LIB>;
	close( LIB );

	$codelines->{'lib'} += int( scalar( @lines ) );

	open( LIB, './data/lib/MSN/P2P.pm' );
		@lines = <LIB>;
	close( LIB );

	$codelines->{'lib'} += int( scalar( @lines ) );

	open( LIB, './data/lib/MSN/Util.pm' );
		@lines = <LIB>;
	close( LIB );

	$codelines->{'lib'} += int( scalar( @lines ) );

	open( LIB, './data/lib/MSN/Notification.pm' );
		@lines = <LIB>;
	close( LIB );

	$codelines->{'lib'} += int( scalar( @lines ) );
	$codelines->{'total'} += $codelines->{'lib'};

	opendir( HANDLERS, './data/handlers/' );
		foreach my $handler( readdir( HANDLERS ) )
		{
			next if( $handler =~ m/^\.{1,2}$/ );
			next if( -d( './data/handlers/'.$handler ) );

			open( FILE, './data/handlers/'.$handler );
				my @lines = <FILE>;
			close( FILE );
			$codelines->{'handlers'} += int( scalar( @lines ) );
		}
	closedir( HANDLERS );

	$codelines->{'total'} += $codelines->{'handlers'};

	opendir( COMMANDS, './data/commands/' );
		foreach my $category( readdir( COMMANDS ) )
		{
			#next if( $category == '.' || $category == '..' );

			opendir( CATEGORY, './data/commands/'.$category );
				foreach my $command( readdir( CATEGORY ) )
				{
					next if( $command =~ m/^\.{1,2}$/ );
					next if( -d( './data/commands/'.$category.'/'.$command ) );

					open( FILE, './data/commands/'.$category.'/'.$command ) or die( 'Error Loading Commands: Unable to Open File '.$command."\n" );
						my @lines = <FILE>;
					close( FILE );
					$codelines->{'commands'} += int( scalar( @lines ) );
				}
			closedir( CATEGORY );
		}
	closedir( COMMANDS );

	$codelines->{'total'} += codelines->{'commands'};

	open( BRAIN, './data/Brains/Chatbot/Eliza.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} = int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Banter/Banter.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Echo/Echo.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Blab/Blab.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Trigger/Trigger.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Rive/RiveScript.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Rive/RiveScript/Brain.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Rive/RiveScript/Parser.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );

	open( BRAIN, './data/Brains/Rive/RiveScript/Util.pm' );
		@lines = <BRAIN>;
	close( BRAIN );

	$codelines->{'brains'} += int( scalar( @lines ) );
	$codelines->{'total'} += $codelines->{'brains'};

	open( MEDIA, './data/Media/music.txt' );
		@lines = <MEDIA>;
	close( MEDIA );

	$codelines->{'media'} = int( scalar( @lines ) );
	$codelines->{'total'} += $codelines->{'media'};

	$self->sendMessage( 'I am made up of '.$codelines->{'total'}.' lines of code'."\n".
			"Bot: ".$codelines->{'bot'}." lines\n".
			"Configuration: ".$codelines->{'config'}." lines\n".
			"Library: ".$codelines->{'lib'}." lines\n".
			"Event Handlers: ".$codelines->{'handlers'}." lines\n".
			"Commands: ".$codelines->{'commands'}." lines\n".
			"Brains & AI: ".$codelines->{'brains'}." lines\n".
			"Media Data: ".$codelines->{'media'}." lines\n".
			"TOTAL: ".$codelines->{'total'}." lines" );

return( 1 );
}