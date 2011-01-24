#Called when a contact opens a conversation with the bot
sub
{
	my( $self, $email, $friendly ) = @_;
	&UpdateDisplay( 'openconvos' => $bot->{'details'}->{'openconvos'}+1 );
}