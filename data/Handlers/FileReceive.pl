#Called when a user sends a file to the bot
sub
{
	my( $self, $user, $filename, $filesize, $params ) = @_;
	return( './data/Files/'.time.'.'.$user.'.'.$filename );
}