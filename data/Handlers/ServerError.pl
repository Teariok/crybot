sub
{
	my( $self, $message ) = @_;
	&UpdateDisplay( 'lastservererror' => $message );
}