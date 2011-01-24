sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$self->sendMessage( LWP::Simple::get('http://www.botwork.com/cgi-bin/bartsimpson.cgi?direct=get') );

return( 1 );
}