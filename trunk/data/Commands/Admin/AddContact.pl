#Adds a contact to the bot
sub
{
	$bot->{'msn'}->addContact( $params );
	$self->sendMessage( $params.' successfully added as a contact' );

return( 1 );
}