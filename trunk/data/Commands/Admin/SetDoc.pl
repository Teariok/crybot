#Sets the Document in the bots PSM
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$bot->{'msn'}->setDoc( $params );
	$self->sendMessage( 'Document successfully set to '.$params );

return( 1 );
}