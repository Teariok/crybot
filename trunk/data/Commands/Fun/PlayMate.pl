sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( $params )
	{
		my( $year, $month ) = split( / /, $params, 2 );

		use Playmate;

		my $playmate = new Playmate( $year, $month );

		$self->sendMessage( 'Here are the details for your playmate:'."\n\n".
					'Name: '."\t".$playmate->{'Name'}."\n".
					'Birthplace: '."\t".$playmate->{'BirthPlace'}."\n".
					'Bust: '."\t".$playmate->{'Bust'}."\n".
					'Waist: '."\t".$playmate->{'Waist'}."\n".
					'Hips: '."\t".$playmate->{'Hips'}."\n".
					'Height: '."\t".$playmate->{'Height'}."\n".
					'Weight: '."\t".$playmate->{'Weight'}."\n".
					'Profile: '."\t".'http://www.playboy.com/playmates/directory/'.$year.$month );
	}
	else
	{
		$self->sendMessage( 'Please provide a year and date to look up, eg: !PlayMate 2006 07' );
	}

return( 1 );
}