#Re-Loads the bot commands
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( &LoadCommands() )
	{
		$self->sendMessage( 'Commands reloaded successfully' );
	}
	else
	{
		$self->sendMessage( 'Command load error' );
	}

return( 1 );
}