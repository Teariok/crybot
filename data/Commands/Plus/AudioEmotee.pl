sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	#1 = cartoons/games
	#2 = TV/Movies
	#3 = Music
	#4 = Vocals
	#5 = Sound Effects

	use LWP::Simple;
	my ($id) = head('http://sounds.msgpluslive.net/esnd/snd/random?catId=2')->
      				{_headers}->{'content-disposition'} =~ m/#(.*?)\./;

	$self->sendMessage( '[Messenger Plus! Sound] - Data{'.$id.'}\302\240-\302\240Random Song\302\240' );

return( 1 );
}