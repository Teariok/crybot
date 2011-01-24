sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$self->sendSharedSearch( $params );

return( 1 );
}