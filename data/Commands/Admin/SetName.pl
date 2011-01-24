#Sets the disply name of the bot
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->setName( $params );
	$self->sendMessage( 'The name was set to '.$params.' successfully' );

return( 1 );
}