sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$self->sendMessage( 'Exiting the conversation by request of '.$user );
	$self->leave();

return( 1 );
}