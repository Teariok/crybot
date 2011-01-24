sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$self->{P2P}->sendinvite();

return( 1 );
}