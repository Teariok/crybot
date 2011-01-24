#Blocks the user from talking to the bot
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->broadcast( $params );

return( 1 );
}