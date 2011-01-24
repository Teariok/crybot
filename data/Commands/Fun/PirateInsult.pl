sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	use Acme::Scurvy::Whoreson::BilgeRat;

	my $insult = Acme::Scurvy::Whoreson::BilgeRat->new( language => 'pirate' );

	$self->sendMessage( ' Ye '.$insult );

return( 1 );
}