#Called when a contact leaves a conversation
sub
{
	my( $self, $email ) = @_;
	system( 'say 0 "'.$email.' left the conversation"' );
}