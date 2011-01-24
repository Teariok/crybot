#Called when a conversation is closed
sub
{
	my( $self ) = @_;
	&UpdateDisplay( 'openconvos' => $bot->{'details'}->{'openconvos'}-1 );
}