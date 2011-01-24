#Called when a user changes their status
sub
{
	my( $self, $email, $status ) = @_;
	system( 'say 0 "'.$email.' changed their status to '.$status.'"' );
}