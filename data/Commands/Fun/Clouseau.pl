sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	use Clouseau;

	$self->sendMessage( clouseau( $params ) );

return( 1 );
}