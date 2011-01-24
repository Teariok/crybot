sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	my $reverse = reverse( $params );

	$self->sendMessage( $reverse );

return( 1 );
}