#Re-Loads the msn event handlers
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( &LoadHandlers() )
	{
		$self->sendMessage( 'Handlers reloaded successfully' );
	}
	else
	{
		$self->sendMessage( 'Handler loading error' );
	}

return( 1 );
}