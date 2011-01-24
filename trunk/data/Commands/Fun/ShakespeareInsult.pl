sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	my @one = ( "beslubbering", "infectious", "errant", "spongy", "pribbling",
			"mangled", "warped", "lumpish", "impertinent", "paunchy",
			"yeasty", "craven", "reeky", "droning", "bawdy", "unmuzzled",
			"qualling" );

	my @two = ( "beef-witted", "full-gorged", "dread-bolted", "rude-growing",
			"ill-nurtured", "hell-hated", "tickle-brained", "hasty-witted",
			"fool-born", "ill-breeding", "weather-bitten", "common-kissing",
			"plume-plucked", "doghearted", "bat-fowling", "sheep-biting",
			"motley-minded" );

	my @three = ( "haggard", "barnacle", "death-token", "pignut", "maggot-pie",
			"joit-head", "varlet", "horn-beast", "gudgeon", "lout",
			"wagtail", "canker-blossom", "miscreant", "codpiece", "baggage",
			"ratsbane", "measle" );

	$self->sendMessage( @one[int( rand( scalar( @one ) ) )].' '.@two[int( rand( scalar( @two ) ) )].' '.@three[int( rand( scalar( @three ) ) )] );

return( 1 );
}