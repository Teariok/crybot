#Called when an invitation is received
sub
{
	my( $self, $email, $msg ) = @_;

	if( $msg =~ /1012/ )
	{
		#Chess Club:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947963
		#SChannelState: 0
		#AppID: 20571012
		$self->sendMessage( 'Sorry, I cant play Chess Club' );
	}
	elsif( $msg =~ /1011/ )
	{
		#Bankshot Billiards Club:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947967
		#SChannelState: 0
		#AppID: 20571011
		$self->sendMessage( 'Sorry, I cant play  Billiards Club' );
	}
	elsif( $msg =~ /1072/ )
	{
		#Movin It:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947971
		#SChannelState: 0
		#AppID: 20571072
		$self->sendMessage( 'Sorry, I cant play Movin\' It' );
	}
	elsif( $msg =~ /1021/ )
	{
		#Tic Tac Toe:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947973
		#SChannelState: 0
		#AppID: 20571021
		$self->sendMessage( 'Sorry, I cant play Tic Tac Toe' );
	}
	elsif( $msg =~ /1268/ )
	{
		#Checkers:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947975
		#SChannelState: 0
		#AppID: 20571268
		$self->sendMessage( 'Sorry, I cant play Checkers' );
	}
	elsif( $msg =~ /1270/ )
	{
		#Solitaire Showdown:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947977
		#SChannelState: 0
		#AppID: 20571270
		$self->sendMessage( 'Sorry, I cant play Solitaire Showdown' );
	}
	elsif( $msg =~ /1271/ )
	{
		#Bejewelled:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947979
		#SChannelState: 0
		#AppID: 20571271
		$self->sendMessage( 'Sorry, I cant play Bejewelled' );
	}
	elsif( $msg =~ /1269/ )
	{
		#Minesweeper Flags:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947981
		#SChannelState: 0
		#AppID: 20571269
		$self->sendMessage( 'Sorry, I cant play Minesweeper Flags' );
	}
	elsif( $msg =~ /1358/ )
	{
		#Tic Tac Toe Classic:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}	
		#SessionID: 25947983
		#SChannelState: 0
		#AppID: 20571358
		$self->sendMessage( 'Sorry, I cant play Classic Tic Tac Toe' );
	}
	elsif( $msg =~ /1364/ )
	{
		#Music Mix:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947987
		#SChannelState: 0
		#AppID: 20571364
		$self->sendMessage( 'Sorry, I cant use Music Mix' );
	}
	elsif( $msg =~ /1001/ )
	{
		#MSN Photo Swap:
		#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
		#SessionID: 25947989
		#SChannelState: 0
		#AppID: 20571001
		$self->sendMessage( 'Sorry, I cant use MSN Photo Swap' );
	}
	elsif( $msg =~ /1003/ )
	{
    		#Hexic
		$self->sendMessage( 'Sorry, I cant play Hexic' );
	}
	elsif( $msg =~ /1004/ )
	{
		#Xpress Greetings
		$self->sendMessage( 'Sorry, I cant use Xpress Greetings' );
	}
	elsif( $msg =~ /1005/ )
	{
		#Cubis
		$self->sendMessage( 'Sorry, I cant play Cubis' );
	}
	elsif( $msg =~ /1006/ )
	{
		#Pegball
		$self->sendMessage( 'Sorry, I cant play Pegball' );
	}
	elsif( $msg =~ /1007/ )
	{
		#Mozaki Blocks
		$self->sendMessage( 'Sorry, I cant play Mozaki Blocks' );
	}
	elsif( $msg =~ /1008/ )
	{
		#4Across Birds
		$self->sendMessage( 'Sorry, I cant play 4-Across Birds' );
	}
	elsif( $msg =~ /1013/ )
	{
		#Wheel Of Fortune
		$self->sendMessage( 'Sorry, I cant play Wheel of Fortune' );
	}
	elsif( $msg =~ /1014/ )
	{
		#Upwords Club
		$self->sendMessage( 'Sorry, I cant play Upwords Club' );
	}
	elsif( $msg =~ /1015/ )
	{
		#MSN Calendar Sharing
		$self->sendMessage( 'Sorry, I cant use MSN Calendar Sharing' );
	}
	elsif( $msg =~ /1016/ )
	{
		#Mixed Messages
		$self->sendMessage( 'Sorry, I cant use Mixed Messages' );
	}
	elsif( $msg =~ /1017/ )
	{
		#Audio Emoticons
		$self->sendMessage( 'Sorry, I cant use Audio Emoticons' );
	}
	elsif( $msg =~ /1360/ )
	{
		#File Sharing
		$self->sendMessage( 'Sorry, I cant use File Sharing'."\nBut I can use file transfer :)" );
	}
	elsif( $msg =~ /1361/ )
	{
		#Movie Trailers
		$self->sendMessage( 'Sorry, I cant use Movie Trailers' );
	}
	elsif( $msg =~ /1113/ )
	{
		#Big Monster Battle
		$self->sendMessage( 'Sorry, I cant play Monster Battle' );
	}
	elsif( $msg =~ /1108/ )
	{
		#Dead Mans Tale
		$self->sendMessage( 'Sorry, I cant play Pirates of the Caribbean: Dead Mans Tale' );
	}
	elsif( $msg =~ /1101/ )
	{
		#The Da Vinci Code
		$self->sendMessage( 'Sorry, I cant play The Da Vinci Code' );
	}
	elsif( $msg =~ /1106/ )
	{
		#Messenger Cup 2006
		$self->sendMessage( 'Sorry, I cant play Messenger Cup 2006' );
	}
	elsif( $msg =~ /1069/ )
	{
		#The Secret Girls Dress Up Game
		$self->sendMessage( 'Sorry, I cant play The Secret Girls Dressup Game' );
	}
	elsif( $msg =~ /1038/ )
	{
		#Windows Live Safety Scanner
		$self->sendMessage( 'Sorry, I cant use Windows Live Safety Scanner' );
	}
	elsif( $msg =~ /1024/ )
	{
		#7 Hand Poker
		$self->sendMessage( 'Sorry, I cant play 7-Hand Poker' );
	}
	elsif( $msg =~ /1025/ )
	{
		#Mah Jong Tiles
		$self->sendMessage( 'Sorry, I cant play Mah Jong Tiles' );
	}
	elsif( $msg =~ /1026/ )
	{
		#Blowkwartet
		$self->sendMessage( 'Sorry, I cant play Blowkwartet' );
	}
	elsif( $msg =~ /1271/ )
	{
		#Bejewelled Valentine
		$self->sendMessage( 'Sorry, I cant play Bejewelled Valentine' );
	}
	elsif( $msg =~ /1022/ )
	{
		#Monsters Backgammon, Pegball, mer
		$self->sendMessage( 'Sorry, I cant play Monsters Backgammon, Pegball, or "mer"' );
	}
	elsif( $msg =~ /99991050/ )
	{
		#FM Serious Request
		$self->sendMessage( 'Sorry, I cant play FM3 Serious Request' );
	}
	elsif( $msg =~ /1018/ )
	{
		#Nike Olé
		$self->sendMessage( 'Sorry, I cant play Nike Ole' );
	}
	elsif( $msg =~ /10331023/ )
	{
		#Miles Thirst: The Conversationator
		$self->sendMessage( 'Sorry, I cant play Miles Thirst: The Conversationator' );
	}
	elsif( $msg =~ /5083/ )
	{
		#Cobauw Penalty
		$self->sendMessage( 'Sorry, I cant play Cobauw Penalty' );
	}
	elsif( $msg =~ /10315102/ )
	{
		#MSN Soccer
		$self->sendMessage( 'Sorry, I cant play MSN Soccer' );
	}
	elsif( $msg =~ /AppID: 4/ )
	{
		if( $msg =~ /1C9AA97E-9C05-4583-A3BD-908A196F1E92/ )
		{
			#Web Cam
			#EUF-GUID: {1C9AA97E-9C05-4583-A3BD-908A196F1E92}
			#SessionID: 191334492
			#SChannelState: 0
			#AppID: 4
			$self->sendMessage( 'Sorry, I cant use my Webcam' );
		}
		elsif( $msg =~ /4BD96FC0-AB17-4425-A14A-439185962DC8/ )
		{
			#Video Call
			#EUF-GUID: 4BD96FC0-AB17-4425-A14A-439185962DC8}
			#SessionID: 25947985
			#SChannelState: 0
			#AppID: 4
			$self->sendMessage( 'Sorry, I cant take Video Calls' );
		}
	}
	elsif( $msg =~ /AppID: 2/ )
	{
		#File Transfer:
		#EUF-GUID: {5D3E02AB-6190-11D3-BBBB-00C04F795683}
		#SessionID: 25947991
		#SChannelState: 0
		#AppID: 2
	}
#MSN Sporkle Games
#EUF-GUID: {6A13AF9C-5308-4F35-923A-67E8DDA40C2F}
#SessionID: 431003962
#SChannelState: 0
#AppID: 10301006

open( LOG, '>>./invitations.txt' );
	print( LOG $msg );
close( LOG ); 

	return( 1 );
}