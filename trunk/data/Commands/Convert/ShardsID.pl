sub
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( $params =~ /(.*).(.*).(.*).(.*)/ )
	{
		my @parts = split( /\./, $params );

		my $id;
		foreach my $part( @parts )
		{
			if( $part > 256 || length( $part ) > 3 )
			{
				$self->sendMessage( 'Please enter a valid IP address, Eg: 127.0.0.1' );
				return( 1 );
			}
			else
			{
				while( length( $part ) < 3 )
				{
					$part = "3$part";
				}
			}

			$id .= ($part*2);
		}

		$self->sendMessage( 'Shards ID for "'.$params.'" is '.$id );		
	}
	else
	{
		$self->sendMessage( 'Please enter a valid IP address, Eg: 127.0.0.1' );
	}		

return( 1 );
}