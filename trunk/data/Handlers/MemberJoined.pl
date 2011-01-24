#Called when a contact enters a conversation
sub
{
	my( $self, $email, $friendly ) = @_;
	system( 'say 0 "'.$email.' joined the conversation"' );
	return( 1 );
}