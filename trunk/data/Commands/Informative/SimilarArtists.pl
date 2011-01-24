sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	$params =~ s/ /\+/g;

	use LWP::UserAgent;
	my $ua = LWP::UserAgent->new;
	$ua->agent( 'Crybot (teario@hotmail.com)' );

	my $req = HTTP::Request->new(POST => 'http://www.allmusic.com/cg/amg.dll');
	$req->content_type('application/x-www-form-urlencoded');
	$req->content('P=amg&sql='.$params.'&opt1=1');

	my $res = $ua->request($req);

	if ($res->is_success)
	{
		my $content = $res->content;
		$content =~ m!<div.*?>Similar Artists</div>(<ul>.*?</ul>)!;
		my @Similar = ( $1 =~ m!<a.*?>(.*?)</a>!g );

		$self->sendMessage( $Similar[1] );
		$self->sendMessage( 'Done' );
	}
  	else
	{
		$self->sendMessage( 'Failure' );
		#print $res->status_line, "\n";
	}

return( 1 );
}