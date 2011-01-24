sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( $params =~ /off/i )
	{
		$self->{'canreply'} = 'false';
		$self->sendMessage( 'Responses Turned Off For This Conversation' );
	}
	else
	{
		$self->{'canreply'} = 'true';
		$self->sendMessage( 'Responses Turned On For This Conversation' );
	}

return( 1 );
}