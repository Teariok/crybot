sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	my @ipinfo = split( "\n", LWP::Simple::get( 'http://beastserver.hopto.org/~teario/google/locate/?ip='.$params ) );

	if( scalar( @ipinfo ) > 1 )
	{
		$info = "City: ".$ipinfo[0]."\n".
			"Country: ".$ipinfo[1]."\n".
			"Country abbrev: ".$ipinfo[2]."\n";

	if( $ipinfo[3] )
	{
		$info .= "Latitude: ".$ipinfo[3]."\n".
		"Longitude: ".$ipinfo[4]."\n".
		"Map: ".'http://beastserver.hopto.org/~teario/google/locate/locinfo.php?lat='.$ipinfo[3].'&lng='.$ipinfo[4];
		}
	}
	else
	{
		$info = $ipinfo[0];
	}

	$self->sendMessage( $info, %style );
}