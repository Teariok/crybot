#Called when a user sends a message to the bot
sub
{
	my( $self, $user, $friendly, $message, %style ) = @_;

	&UpdateDisplay( 'lastmsgtext' => $message, 'lastmsgsender' => $user );

	if( $message =~ /^\!/ )
	{
		&RunCommand( $self, $user, $friendly, $message, %style );
	}
	else
	{
		if( $self->{'canreply'} eq 'false' ){ return( undef ); }

		my @reply = $bot->{brains}->{$bot->{details}->{brain}}->transform( $user, $message );

		my $response = $reply[0];
		if( $response eq 'ERR: No Reply Found' )
		{
			open( NOREP, '>>./norivereply.txt' );
				print( NOREP $message."\n" );
			close( NOREP );

			$response = $bot->{'brains'}->{'eliza'}->transform( $message );
		}

		$self->sendMessage( $response );

		system( 'say 0 "'.$user.' says:"' );
		system( 'say 1 "'.$message.'"' );
		system( 'say 0 "My response is: '.$response.'"' );

		open( LOG, '>>./data/logs/'.$user.'.txt' );
			print( LOG 'User: '.$message."\n".'Bot: '.$response."\n" );
		close( LOG );
	}
}