sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	my @responses = ( 'Yes', 'No', 'Ask Again Later', 'Most Definately', 'Certainly', 'Certainly Not', 'Never', 'Uncertain' );

	my( $yesno, $question ) = split( / /, $params, 2 );

	if( $yesno =~ /is|can|am|do|are|does|did|will/ig )
	{
		$self->sendMessage( $responses[int( rand( scalar( @responses ) ) )] );
	}
	else
	{
		$self->sendMessage( 'Please ask a yes/no question, for example: Will I become a millionaire?' );
	}

return( 1 );
}