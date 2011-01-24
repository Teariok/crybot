#Called when a contact adds us to their FL
sub
{
	my( $self, $email ) = @_;

	&UpdateDisplay( 'numcontacts' => scalar( $bot->{'msn'}->getContactList( 'AL' ) )+1 );

	return( 1 );
}