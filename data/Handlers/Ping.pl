#Called when the server send a Ping Message
sub
{
	my( $self, $user, $friendly, $headers, $settings ) = @_;

	my( $sec, $min, $hour ) = localtime(time);

	$sec = "0$sec" if( $sec < 10 );
	$min = "0$min" if( $min < 10 );
	$hour = "0$hour" if( $hour < 10 );

	&UpdateDisplay( 'pingtime' => $hour.':'.$min.':'.$sec );
}