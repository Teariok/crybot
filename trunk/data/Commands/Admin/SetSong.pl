#Sets the Song in the bots PSM
sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	my @songinfo = split( /\+/, $params );
	$bot->{'msn'}->setSong( @songinfo );

	$self->sendMessage( 'Song successfully set to '.join( ' - ', @songinfo ) );

return( 1 );
}