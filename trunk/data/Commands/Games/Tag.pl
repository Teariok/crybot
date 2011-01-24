sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( $bot->{'msn'}->getContactStatus( $params ) =~ /NLN|PHN|BSY|AWY|BRB|LUN|HDN|IDL/i )
	{
		$bot->{'msn'}->call( $params, 'You have just been IM-Tagged by '.$user.' and now youre \'it\'.'."\n\n".
				'To IM-Tag someone else, tpye !tag <email address>.' );
		$self->sendMessage( 'You have just tagged '.$user.' and made them \'it\'.' );
	}
	else
	{
		$self->sendMessage( 'Sorry, the user '.$params.' is either offline, has not added the bot, or does not exist.'."\n\n".
					'Due to MSN privacy settings, you can only IM-Tag someone who has added the bot, or accepts messages from any user.' );
	}

return( 1 );
}