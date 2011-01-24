#Called when a contact removes us from their FL
sub
{
	my( $self, $email ) = @_;
	&UpdateDisplay( 'numcontacts' => scalar( $bot->{'msn'}->getContactList( 'AL' ) )-1 );
}