sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	#1 = cartoons/games
	#2 = TV/Movies
	#3 = Music
	#4 = Vocals
	#5 = Sound Effects

	require HTTP::Request;
	my $request = HTTP::Request->new( GET => 'http://sounds.msgpluslive.net/esnd/snd/random?catId=2' );
	my $ua = LWP::UserAgent->new( agent => 'MessengerPlusLive' );
	my $response = $ua->request($request);

	my $data = $response->{'_headers'}->header( 'content-disposition' );

	$data =~ m/"#(.*?)\..*?"/;
	my $id = $1;

	$self->sendMessage( '[Messenger Plus! Sound] - Data{'.$id.'}\302\240-\302\240Random Song\302\240' );

return( 1 );
}