#Called when the server pings the bot
sub
{
	my( $self ) = @_;

	my( $sec, $min, $hour, $day, $month, $year ) = localtime(time);

	$year += 1900;

	$sec = "0$sec" if( $sec < 10 );
	$min = "0$min" if( $min < 10 );
	$hour = "0$hour" if( $hour < 10 );
	$month++;
	$month = "0$month" if( $month < 10 );
	$day = "0$day" if( $day < 10 );

	&UpdateDisplay( 'connectedtime' => $hour.':'.$min.':'.$sec.' '.$day.'/'.$month.'/'.$year,
			'openconvos' => 0,
			'numcontacts' => scalar( $bot->{'msn'}->getContactList( 'AL' ) ) );

	$bot->{'msn'}->setName( $bot->{'details'}->{'displayname'} );
	$bot->{'msn'}->setPSM( $bot->{'details'}->{'psm'} );
	$bot->{'msn'}->setDisplayPicture( './data/DisplayPics/'.$bot->{'details'}->{'displaypic'}.'.png' );

	$bot->{'timers'}->add( code => \&ChangeSong, interval => 60 );
}