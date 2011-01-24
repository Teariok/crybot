#Sets the Game in the bots PSM
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->setGame( $params );
	$self->sendMessage( 'Game successfully set to '.$params );

return( 1 );
}