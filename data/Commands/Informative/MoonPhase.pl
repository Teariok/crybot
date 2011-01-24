sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	use MoonPhase;

	my( $moonphase, $moonillum, $moonage, $moondist, $moonang, $sundist, $sunang ) = phase(time);
	my( $newmoon, $firstquat, $full, $lastquat, undef ) = phasehunt(time);

	$self->sendMessage( 'New Moon: '."\t".scalar( localtime( $newmoon ) )."\n".
				'First Quater: '."\t".scalar( localtime( $firstquat ) )."\n".
				'Full Moon: '."\t".scalar( localtime( $full ) )."\n".
				'Last Quater: '."\t".scalar( localtime( $lastquat ) ) );
return( 1 );
}