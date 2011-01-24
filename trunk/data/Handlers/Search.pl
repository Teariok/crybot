#Called when a user sends msn shared search to the bot
sub
{
	my( $self, $user, $friendly, $query, %style ) = @_;
	&UpdateDisplay( 'lastmsgsender' => $user,
			'lastmsgtext' => $query );
}