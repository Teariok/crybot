#unblocks the user
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$self->actionMessage( $params );

return( 1 );
}