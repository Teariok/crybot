sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	use MIME::Base64;

	$self->sendMessage( 'Original String:'."\n\t".$params."\n".
				'Base64 String:'."\n\t".encode_base64( $params ) );

return( 1 );
}