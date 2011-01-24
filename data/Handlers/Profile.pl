#Called when the profile info is received
sub
{
	my( $self, $header, $data ) = @_;

	$bot->{'details'}->{'profile'}->{'received'} = 1;

	$bot->{'details'}->{'profile'} = $header;
}