#Called when a user sends Ink to the bot
sub
{
	my( $self, $ink ) = @_;

	open( INK, '>./data/Ink/'.time.'.isf' );
		print( INK $ink );
	close( INK );
}