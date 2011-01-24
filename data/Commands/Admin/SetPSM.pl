#Sets the PSM of the bot
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->setPSM( $params );
	$self->sendMessage( 'PSM successfully set to '.$params );

return( 1 );
}