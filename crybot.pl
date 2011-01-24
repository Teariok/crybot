#                            o-o o--o  o   o o--o   o-o  o-O-o 
#                           /    |   |  \ /  |   | o   o   |   
#                          O     O-Oo    O   O--o  |   |   |   
#                           \    |  \    |   |   | o   o   |   
#                            o-o o   o   o   o--o   o-o    o   



use lib "./data/lib";
use lib "./data/brains";
use lib "./data";

use MSN;
use XML::Simple;
use Timer;
use IO::Socket;

use Banter::Banter;
use Blab::Blab;
use Trigger::Trigger;
use Echo::Echo;
use Chatbot::Eliza;
use Rive::RiveScript;
#use Wabby::Wabby;
#use Werder::Werder;

my $bot;
our $AUTOLOAD;
my $xs = new XML::Simple;

&LoadBot();

$bot->{'msn'}->connect();


while( 1 )
{
	$bot->{'msn'}->do_one_loop();
	$bot->{'timers'}->run();
}

sub AUTOLOAD
{
	$bot->{'msn'}->call_event( 'error', "Unrecognised Command: ".$AUTOLOAD );
}

sub LoadBot
{
	$bot = $xs->XMLin( './data/bots/crybot.xml' );

	$bot->{'msn'} = new MSN( Handle => $bot->{'details'}->{'email'},
				Password => $bot->{'details'}->{'password'},
				Status => $bot->{'details'}->{'status'},
				Debug => $bot->{'details'}->{'debug'},
				ServerError => $bot->{'details'}->{'servererror'},
				Error => $bot->{'details'}->{'error'},
				AutoloadError => $bot->{'details'}->{'autoloaderror'},
				CMDError => $bot->{'details'}->{'cmderror'},
				ShowTX => $bot->{'details'}->{'showtx'},
				ShowRX => $bot->{'details'}->{'showrx'},
				AutoReconnect => $bot->{'details'}->{'autoreconnect'} );

	$bot->{'msn'}->setClientInfo( Client => $bot->{'clientinfo'}->{'client'},
					WinMobile => $bot->{'clientinfo'}->{'winmobile'},
					GifInk => $bot->{'clientinfo'}->{'gifink'},
					ISFInk => $bot->{'clientinfo'}->{'isfink'},
					Video => $bot->{'clientinfo'}->{'video'},
					MultiPacket => $bot->{'clientinfo'}->{'multipacket'},
					MSNMobile => $bot->{'clientinfo'}->{'msnmobile'},
					MSNDirect => $bot->{'clientinfo'}->{'msndirect'},
					WebMessenger => $bot->{'clientinfo'}->{'webmessenger'},
					InternalClient => $bot->{'clientinfo'}->{'internalclient'},
					DirectIM => $bot->{'clientinfo'}->{'directim'},
					Winks => $bot->{'clientinfo'}->{'winks'},
					SharedSearch => $bot->{'clientinfo'}->{'sharedsearch'},
					VoiceClips => $bot->{'clientinfo'}->{'voiceclips'},
					VoIP => $bot->{'clientinfo'}->{'voip'},
					SharingFolders => $bot->{'clientinfo'}->{'sharingfolders'},
					Unknown => $bot->{'clientinfo'}->{'unknown'},
					UnknownTwo => $bot->{'clientinfo'}->{'unknowntwo'},
					UnknownThree => $bot->{'clientinfo'}->{'unknownthree'} );

	$bot->{'msn'}->setMessageStyle( %{$bot->{'messagestyle'}} );
	
	$bot->{'msn'}->setClientCaps( %{$bot->{'clientcaps'}} );

	$bot->{'brains'}->{'banter'} = new Banter::Banter;
	$bot->{'brains'}->{'blab'} = new Blab::Blab;
	$bot->{'brains'}->{'trigger'} = new Trigger::Trigger( filename => './data/Brains/Trigger/direct_responses.txt' );
	$bot->{'brains'}->{'echo'} = new Echo::Echo;
	$bot->{'brains'}->{'eliza'} = new Chatbot::Eliza;
#	$bot->{'brains'}->{'wabby'} = new Wabby::Wabby;
#	$bot->{'brains'}->{'werder'} = new Werder::Werder;
#	$bot->{'brains'}->{'werder'}->set_werds_num( 5,20 );
#	$bot->{'brains'}->{'werder'}->set_unlinked( 1 );
#	$bot->{'brains'}->{'werder'}->set_language( 'English' );
	$bot->{'brains'}->{'rive'} = new Rive::RiveScript;
	$bot->{'brains'}->{'rive'}->loadDirectory( './data/Brains/Rive/Aiden' );
	$bot->{'brains'}->{'rive'}->sortReplies();

	$bot->{'timers'} = new Timer;

	$bot->{'details'}->{'logo'} = "\t\t   ".'  o-o o--o  o   o o--o   o-o  o-O-o '."\n".
					"\t\t   ".' /    |   |  \ /  |   | o   o   |   '."\n".
					"\t\t   ".'O     O-Oo    O   O--o  |   |   |   '."\n".
					"\t\t   ".' \    |  \    |   |   | o   o   |   '."\n".
					"\t\t   ".'  o-o o   o   o   o--o   o-o    o   '."\n";

	open( MEDIA, './data/Media/music.txt' );
		local $/ = undef;
		my $data = <MEDIA>;
	close( MEDIA );
	$bot->{music} = eval( $data );

	&LoadHandlers();
	&LoadCommands();
}

sub LoadHandlers
{
	opendir( HANDLERS, './data/handlers/' ) || die( 'Error Loading Handlers: Unable to open directory'."\n" );
		foreach my $handler( readdir( HANDLERS ) )
		{
			next if( $handler =~ m/^\.{1,2}$/ );
			next if( -d( './data/handlers/'.$handler ) );

			open( FILE, './data/handlers/'.$handler ) or die( 'Error Loading Handlers: Unable to Open File '.$handler."\n" );
				local $/ = undef;
				my $data = <FILE>;
			close( FILE );

			my( $handlername ) = ( $handler =~ m/^([A-Z0-9- ]+)/i );
			$bot->{'msn'}->{'handlers'}->{$handlername} = eval( 'return( '.$data.' );' );

			print( "Setting Handler: $handlername\n" );

			$bot->{'msn'}->setHandler( $handlername => \&{$bot->{'msn'}->{'handlers'}->{$handlername}} );

			die( 'Handler Error: '.$@."\n" ) if( $@ );
		}
	closedir( HANDLERS );

return( 1 );
}

sub LoadCommands
{
	opendir( COMMANDS, './data/commands/' ) || die( 'Error Loading Commands: Unable to open directory'."\n" );
		foreach my $category( readdir( COMMANDS ) )
		{
			next if( $category eq '.' );
			next if( $category eq '..' );

			opendir( CATEGORY, './data/commands/'.$category ) or die( 'Error Loading Commands: Unable to open directory '.$category."\n" );
				foreach my $command( readdir( CATEGORY ) )
				{
					next if( $command =~ m/^\.{1,2}$/ );
					next if( -d( './data/commands/'.$category.'/'.$command ) );
					next if( $command =~ /.skip/ );

					open( FILE, './data/commands/'.$category.'/'.$command ) or die( 'Error Loading Commands: Unable to Open File '.$command."\n" );
						local $/ = undef;
						my $data = <FILE>;
					close( FILE );

					my( $commandname ) = ( $command =~ m/^([A-Z0-9- ]+)/i );

					$bot->{'commands'}->{lc($commandname)} = eval( 'return( '.$data.' );' );
					$bot->{'menu'}->{lc($category)} .= $commandname."\n";
					$bot->{'commands'}->{'restricted'}->{lc($commandname)} = lc($category);

					print( "Adding Command: $commandname [./data/commands/$category/$command]\n" );

					die( 'Command Error: '.$@."\n" ) if( $@ );
				}
			closedir( CATEGORY );
			$bot->{'menu'}->{'categorymenu'} .= $category."\n";
		}
	closedir( COMMANDS );

	$bot->{'commands'}->{'menu'} = 'menu';

return( 1 );
}

sub RunCommand
{
	my( $self, $user, $friendly, $message, %style ) = @_;

	my( $cmd, $params ) = split( / /, $message, 2 );

	$cmd =~ s/^\!//;

	if( $bot->{'commands'}->{'restricted'}->{lc($cmd)} eq 'admin' )
	{
		if( $user ne $bot->{'staff'}->{'admin'} )
		{
			$self->sendMessage( $user.', You are not authorised to use the '.$cmd.' command' );
			return( undef );
		}
	}
	return( &{$bot->{'commands'}->{lc($cmd)}}( $self, $user, $friendly, $params, %style ) );
}

sub UpdateDisplay
{

	my %update = @_;

	for my $keys( %update )
	{
		$bot->{'details'}->{$keys} = $update{$keys};
	}

	#system( 'cls' );

	print(	$bot->{'details'}->{'logo'}."\n".
		"BOT:\n".
		" Email Address:\t\t".$bot->{'details'}->{'email'}."\n".
		" Display Name:\t\t".$bot->{'details'}->{'displayname'}."\n".
		" Status:\t\t".$bot->{'details'}->{'status'}."\n".
		" Connected At:\t\t".$bot->{'details'}->{'connectedtime'}."\n".
		" Open Conversations:\t".$bot->{'details'}->{'openconvos'}."\n".
		" Contacts:\t\t".$bot->{'details'}->{'numcontacts'}."\n".
		" Last Message From:\t".$bot->{'details'}->{'lastmsgsender'}."\n".
		" Last Message Text:\t".$bot->{'details'}->{'lastmsgtext'}."\n\n".
		"Debug:\n".
		" Last Debug Message:\t".$bot->{'details'}->{'lastdebug'}."\n".
		" Last Error Message:\t".$bot->{'details'}->{'lasterror'}."\n".
		" Last Server Error:\t".$bot->{'details'}->{'lastservererror'}."\n".
		" Disconnections:\t".$bot->{'details'}->{'disconnections'}."\n".
		" Last Ping Time:\t".$bot->{'details'}->{'pingtime'}."\n" );
}

sub menu
{
	my( $self, $user, $friendly, $params, %style ) = @_;

	if( $params )
	{
		if( $bot->{'menu'}->{lc($params)} )
		{
			$self->sendMessage( 'Here are the commands in the ' .ucfirst($params).' category: '."\n\n".$bot->{'menu'}->{lc($params)} );
		}
		else
		{
			$self->sendMessage( "There is no category \"$params\", for a list of categories, type !menu" );
		}
	}
	else
	{
		$self->sendMessage( "Here is the Command Menu. To see commands in the categories below, type !menu <category>\n\n".$bot->{'menu'}->{'categorymenu'} );
	}
}

#Test commands:
sub ChangeSong
{
	my( undef, $min, $hour, $day, $month, $year ) = localtime(time);

	$year += 1900;

	$min = "0$min" if( $min < 10 );
	$hour = "0$hour" if( $hour < 10 );
	$month++;
	$month = "0$month" if( $month < 10 );
	$day = "0$day" if( $day < 10 );

	$bot->{'msn'}->setPSM( $hour.':'.$min.' '.$day.'.'.$month.'.'.$year.' [GMT]' );
}