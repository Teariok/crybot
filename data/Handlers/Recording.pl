#Called when a user is recording a voice clip
sub
{
	my( $self, $user, $friendly ) = @_;
	$self->sendMessage( 'I cant wait to hear this voice clip :)' );
	system( 'say 0 "'.$user.' is recording a voice clip"' );
}