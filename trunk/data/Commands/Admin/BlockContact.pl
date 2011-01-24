#Blocks the user from talking to the bot
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->blockContact( $params );
	$self->sendMessage( $user.' was successfully blocked' );

return( 1 );
}