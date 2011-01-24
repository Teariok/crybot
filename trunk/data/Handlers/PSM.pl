#Called when a contact changes their psm or currentmedia
sub
{
	use Data::Dumper;

	my( $self, $email, $data ) = @_;

	my( $media ) = ( $data =~ m/<currentmedia>(.*?)<\/currentmedia>/i );

	if( $media )
	{

		my( undef, $type, $mediadata ) = split( '\\\0', $media, 3 );

		if( lc( $type ) eq 'music' )
		{
			my( undef, undef, $title, $artist, $album, $ID ) = split( '\\\0', $mediadata );

			system( 'say 0 "'.$email.' is listening to '.$title.' by'.$artist.'"' );

			$album = 'Unknown Album' unless( $album );

			$bot->{msn}->setSong( $title, $artist, $album );
			$bot->{music}->{$artist}->{$album}->{$title} = $email;

			if( $title && $artist )
			{
				open( MEDIA, '>./data/Media/music.txt' );
					print( MEDIA Dumper $bot->{music} );
				close( MEDIA );
			}

			use LWP::Simple;
			my $letter = substr( $artist, 0, 1 );
			my $nsartist = $artist;
			$nsartist =~ s/ //g;
			my $nssong = $title;
			$nssong =~ s/ //g;
$self->call( 'krazz17@hotmail.com', 'http://www.azlyrics.com/lyrics/'.lc($nsartist).'/'.lc($nssong).'.html' );
			my $source = get( 'http://www.azlyrics.com/lyrics/'.lc($nsartist).'/'.lc($nssong).'.html' );

			if( $source )
			{
				$source =~ s/<br>/\!NEWLINE\!/g;
				$source =~ s/<.*?>//ig;
				$source =~ s/\r|\n//ig;
				$source =~ s/\[.*?\]//ig;
				$source =~ s/\!NEWLINE\!/\n/ig;
				$source =~ s/\&.*?\;//ig;
				$source =~ s/\n\n/\n/g;

				my @lyriclines = split( /\n/, $source );
				my $start = int(rand(scalar(@lyriclines)));
				$start += 3 if( $lyriclines < 3 );
				$start /= 2;
				$start = int( $start );
				my $tosend = $artist .'! :)'."\n".'(8)...'.$lyriclines[$start]."\n".
						$lyriclines[$start+1]."\n".
						$lyriclines[$start+2].'...(8)';

				$self->call( $email, $tosend );
			}
		}
		elsif( lc( $type ) eq 'office' )
		{
			my( undef, undef, $officedata, $ID ) = split( '\\\0', $mediadata );

			$bot->{office}->{$officedata} = $email;

			open( MEDIA, '>./data/Media/office.txt' );
				print( MEDIA Dumper $bot->{office} );
			close( MEDIA );
		}
		elsif( lc( $type ) eq 'game' )
		{
			my( undef, undef, $game, $ID ) = split( '\\\0', $mediadata );

			$bot->{game}->{$game} = $email;

			open( MEDIA, '>./data/Media/game.txt' );
				print( MEDIA Dumper $bot->{game} );
			close( MEDIA );
		}
	}

	return( 1 );
}