#Called when the bot is disconnected from the server
sub
{
	my( $self, $message ) = @_;
	&UpdateDisplay( 'disconnected' => $message );
}