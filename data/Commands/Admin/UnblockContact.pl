#unblocks the user
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->unblockContact( $params );
	$self->sendMessage( $user.' was successfully unblocked' );

return( 1 );
}