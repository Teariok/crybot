/*
	AidenBot RiveScript
	-------------------
	objects.rs - RiveScript Objects
*/

///////////////////////////
// Simple Calculator     //
///////////////////////////

> object calc
	my ($method,$msg) = @_;

	my %words = (
		qw(one 1 two 2 three 3 four 4 five 5 six 6 seven 7 eight 8 nine 9 ten 10
		zero 0 eleven 11 twelve 12 thirteen 13 fourteen 14 fifteen 15 sixteen 16
		seventeen 17 eighteen 18 nineteen 19 twenty 20 thirty 30 forty 40 fifty 50
		sixty 60 seventy 70 eighty 80 ninety 90),
	);

	$msg =~ s~plus~\+~g;
	$msg =~ s~minus~\-~g;
	$msg =~ s~times~\*~g;
	$msg =~ s~divided~/~g;

	foreach my $word (keys %words) {
		$msg =~ s/$word/$words{$word}/ig;
	}

	# Proper operators.
	if ($msg =~ /[^0-9\.\+\-\/\*\(\) ]/i) {
		return "Invalid calculation operators. Valid operators are: "
			. "+ - / * ( ) (msg=$msg)";
	}
	else {
		my $reply = "$msg = " . eval($msg);
		return $reply;
	}

	return "Unknown Error";
< object

> object define
	my ($method,$msg) = @_;

	use LWP::Simple;

	# If there's a message to define...
	if (length $msg > 0) {
		my $src = LWP::Simple::get "http://dictionary.reference.com/search?q=$msg" or return "Could not get dictionary!";
		$src =~ s/\n/ /g;

		# Get the first definition.
		if ($src =~ /<OL><LI>(.*?)<\/LI>/i) {
			my $def = $1;
			$def =~ s/<(.|\n)+?>//ig;

			return "Dictionary.com defines $msg as:\n\n"
				. "1. $def";
		}
		else {
			return "Could not obtain the definition to $msg!";
		}
	}
	else {
		return "Please provide a message when calling this command.";
	}
< object

> object google
	my ($method,$msg) = @_;
return "Error: 0";
	my $key = '';
	if (length $key == 0) {
		# A valid key is required for this command.
		return "This command requires you to obtain a Google Search Key. You "
			. "can get one at http://www.google.com/apis/ . Install the "
			. "Google key by opening settings.cfg in a text editor and "
			. "setting the variable \"googlekey\" and insert the new "
			. "key as its value.";
	}

	use SOAP::Lite;
	my $google = SOAP::Lite->service ('file:./lib/GoogleSearch.wsdl');
	my $query = $msg;
	my $result = $google->doGoogleSearch($key, $query, 0, 5, 'false', '', 'false', '', 'latin1', 'latin1');

	my $reply;
	foreach my $element (@{$result->{resultElements}}) {
		$reply .= "$element->{title}\n"
			. "$element->{URL}\n\n";
	}

	return "Google Search Results\n\n" . $reply;
< object

> object insult
	my ($method,$msg) = @_;

	# List of adjectives.
	my @adj = (
		"amorphous ",
		"annoying ",
		"appaling ",
		"asinine ",
		"atrocious ",
		"bad breathed ",
		"bad tempered ",
		"bewildered ",
		"bizarre ",
		"blithering ",
		"blundering ",
		"boring ",
		"brainless ",
		"bungling ",
		"cantankerous ",
		"clueless ",
		"confused ",
		"contemptible ",
		"cranky ",
		"creepy ",
		"crooked ",
		"crotchety ",
		"crude ",
		"decrepit ",
		"deeply disturbed ",
		"demented ",
		"depraved ",
		"deranged ",
		"despicable ",
		"detestable ",
		"dim-witted ",
		"disdainful ",
		"disgraceful ",
		"disgusting ",
		"dismal ",
		"distasteful ",
		"distended ",
		"dreadful ",
		"drivelling ",
		"dull ",
		"dumb ",
		"embarrassing ",
		"evil-smelling ",
		"facile ",
		"feeble-minded ",
		"flea-bitten ",
		"fractious ",
		"frantic ",
		"friendless ",
		"glutinous ",
		"god-awful ",
		"good-for-nothing ",
		"goofy ",
		"grotesque ",
		"hopeless ",
		"hypocritical ",
		"ignorant ",
		"illiterate ",
		"inadequate ",
		"inane ",
		"incapable ",
		"incompetent ",
		"incredible ",
		"indecent ",
		"indescrible ",
		"inept ",
		"infantile ",
		"infuriating ",
		"inhuman ",
		"insane ",
		"insignificant ",
		"insufferable ",
		"irrational ",
		"irresponsible ",
		"lackluster ",
		"laughable ",
		"lazy ",
		"loathsome ",
		"low budget ",
		"malodorous ",
		"misanthropic ",
		"miserable ",
		"monotonous ",
		"nauseating ",
		"neurotic ",
		"obese ",
		"oblivious ",
		"obnoxious ",
		"obsequious ",
		"opinionated ",
		"outrageous ",
		"pathetic ",
		"perverted ",
		"pitiable ",
		"pitiful ",
		"pointless ",
		"pompous ",
		"predictable ",
		"preposterous ",
		"psychotic ",
		"pustulent ",
		"rat-faced ",
		"recalcitrant ",
		"reprehensible ",
		"repulsive ",
		"retarded ",
		"revolting ",
		"rediculous ",
		"rotund ",
		"shameless ",
		"sick ",
		"sickening ",
		"sleazy ",
		"sloppy ",
		"stupid ",
		"superficial ",
		"sycophantic ",
		"tacky ",
		"testy ",
		"ugly ",
		"unbelievable ",
		"uncouth ",
		"uneducated ",
		"ungodly ",
		"unholy ",
		"unimpressive ",
		"upsetting ",
		"useless ",
		"vile ",
		"violent ",
		"vomitous ",
		"witless ",
		"worthless ",
	);
	my @first = (
		"accumulation of ",
		"apology for ",
		"assortment of ",
		"bag of ",
		"ball of ",
		"barrel of ",
		"blob of ",
		"bowl of ",
		"box of ",
		"bucket of ",
		"bunch of ",
		"cake of ",
		"clump of ",
		"collection of ",
		"container of ",
		"contribution of ",
		"crate of ",
		"crock of ",
		"chunk of ",
		"eruption of ",
		"excuse for ",
		"glob of ",
		"heap of ",
		"load of ",
		"loaf of ",
		"lump of ",
		"mass of ",
		"mound of ",
		"mountain of ",
		"pile of ",
		"sack of ",
		"shovel-full of ",
		"stack of ",
		"toilet-full of ",
		"truckload of ",
		"tub of ",
		"vat of ",
	);
	my @second = (
		"cheesy ",
		"clammy ",
		"contaminated ",
		"crummy ",
		"crusty ",
		"cute ",
		"decaying ",
		"decomposed ",
		"defective ",
		"dehydrated ",
		"dirty ",
		"fermenting ",
		"festering ",
		"fly-covered ",
		"foreign ",
		"fornicating ",
		"fossilised ",
		"foul ",
		"freeze dried ",
		"fresh ",
		"fusty ",
		"grimey ",
		"grisly ",
		"gross ",
		"greusome ",
		"imitation ",
		"industrial-strength ",
		"infected ",
		"infested ",
		"laughable ",
		"lousy ",
		"malignant ",
		"mildewed ",
		"musty ",
		"moldy ",
		"mutilated ",
		"nasty ",
		"nauseating ",
		"old ",
		"petrified ",
		"polluted ",
		"putrid ",
		"radioactive ",
		"rancid ",
		"raunchy ",
		"recycled ",
		"rotten ",
		"sloppy ",
		"sloshy ",
		"smelly ",
		"soggy ",
		"soppy ",
		"spoiled ",
		"stale ",
		"steaming ",
		"stenchy ",
		"stinky ",
		"sun-ripened ",
		"synthetic ",
		"unpleasant ",
		"yeasty ",
		"wormy ",
	);
	my @third = (
		"aardvark effluent",
		"ape puke",
		"armpit hairs",
		"baboon asses",
		"bat dumplings",
		"bile",
		"braised pus",
		"buffalo excrement",
		"buzzard barf",
		"camel fleas",
		"donkey manure",
		"chicken guts",
		"cigar butts",
		"cockroaches",
		"compost",
		"cow crud",
		"cow pies",
		"coyote snot",
		"dandruff flakes",
		"dirty underwear",
		"dog barf",
		"dog meat",
		"dog phlegm",
		"donkey droppings",
		"ear wax",
		"eel guts",
		"foot fungus",
		"dung",
		"toe jam",
		"garbage",
		"hemorrhoids",
		"hippo vomit",
		"smegma",
		"hog livers",
		"jock straps",
		"kangaroo vomit",
		"knob cheese",
		"leprosy scabs",
		"llama spit",
		"herpes scabs",
		"maggot brains",
		"monkey shit",
		"moose entrails",
		"mule froth",
		"nasal hairs",
		"naval lint",
		"parrot droppings",
		"nose pickings",
		"penile warts",
		"pig bowels",
		"pig slop",
		"pigeon bombs",
		"pimple pus",
		"pimple squeezings",
		"puke lumps",
		"pustulence",
		"rabbit raisins",
		"rat bogies",
		"rodent droppings",
		"sewage",
		"rubbish",
		"sewer seepage",
		"shark snot",
		"sheep droppings",
		"sinus clots",
		"sinus drainage",
		"skid marks",
		"skunk waste",
		"sludge",
		"slug slime",
		"snake innards",
		"stable sweepings",
		"stomach acid",
		"swamp mud",
		"sweat socks",
		"swime remains",
		"toad tumors",
		"tripe",
		"turkey puke",
		"testicle warts",
		"vulture gizzards",
		"walrus blubber",
		"weasel warts",
		"whale waste",
		"wookie hair",
		"zit cheeze",
	);

	# Get random values.
	my $one = $adj [ int(rand(scalar(@adj))) ];
	my $two = $first [ int(rand(scalar(@first))) ];
	my $three = $second [ int(rand(scalar(@second))) ];
	my $four = $third [ int(rand(scalar(@third))) ];

	# Return this insult.
	return $one . $two . $three . $four;
< object

> object stats
	my ($method,$data) = @_;

	my @stats = &main::stats();
	my ($h,$m,$s) = split(/:/, $stats[12]);
	return "<b>Current Statistics</b>\n\n"
		. "Aiden Version $stats[0]\n\n"
		. "Uptime: "
		. "$h h, $m m, $s s\n"
		. "Bots Connected: $stats[1]\n"
		. "Replies: $stats[3]\n\n"
		. "Last Client: $stats[4]\n"
		. "Clients: $stats[5]\n"
		. "Blocked Users: $stats[6] ($stats[7])\n"
		. "Banned Users: $stats[10] ($stats[11])\n"
		. "Warners: $stats[8] ($stats[9])";
< object

> object weather
	my ($method,$msg) = @_;

	use LWP::Simple;

	if ($method eq 'getfromprofile') {
		$msg = $main::aiden->{clients}->{$msg}->{zipcode};
		if (not defined $msg) {
			return "I don't know your zip code. Type \""
				. "WEATHER ZIPCODE\" to tell me your zip code. "
				. "Then I'll remember it for you.";
		}
	}

	# Message must be proper US zipcode.
	if (length $msg != 5 || $msg =~ /[^0-9]/) {
		return "I need a valid 5-digit US zip code to get your weather.";
	}

	# Get the weather.com info.
	my $src = LWP::Simple::get "http://www.weather.com/weather/local/$msg?lswe=$msg&lwsa=WeatherLocalUndeclared&from=whatwhere";
	$src =~ s/\n//g;
	$src =~ s/\r//g;

	# Weather data.
	my %weather = (
		location   => "<B>Right Now for<\/B><BR>(.*?)<BR>",
		temp       => '<B CLASS=obsTempTextA>(.*?)<\/B><BR><B CLASS=obsTextA>Feels Like',
		feels_like => '<B CLASS=obsTextA>Feels Like<BR> (.*?)<\/B>',
		uv_index   => '<TD VALIGN=\"top\"  CLASS=\"obsTextA\" WIDTH=\"75\" >UV Index:<\/td>.*?<TD><IMG SRC=\"http:\/\/image\.weather\.com\/web\/blank\.gif\" WIDTH=10 HEIGHT=1 BORDER=0 ALT=\"\"></td>.*?<TD VALIGN=\"top\"  CLASS=\"obsTextA\">(.*?)<\/td>',
		wind       => '<TD VALIGN=\"top\"  CLASS=\"obsTextA\" WIDTH=\"75\" >Wind:<\/td>.*?<TD><IMG SRC=\"http:\/\/image\.weather\.com\/web\/blank\.gif\" WIDTH=10 HEIGHT=1 BORDER=0 ALT=\"\"></td>.*?<TD VALIGN=\"top\"  CLASS=\"obsTextA\">(.*?)<\/td>',
		humidity   => '<TD VALIGN=\"top\"  CLASS=\"obsTextA\">Humidity:<\/td>.*?<TD><IMG SRC=\"http:\/\/image\.weather\.com\/web\/blank\.gif\" WIDTH=10 HEIGHT=1 BORDER=0 ALT=\"\"></td>.*?<TD VALIGN=\"top\"  CLASS=\"obsTextA\">(.*?)<\/td>',
		pressure   => '<TD VALIGN=\"top\"  CLASS=\"obsTextA\">Pressure:<\/td>.*?<TD><IMG SRC=\"http:\/\/image\.weather\.com\/web\/blank\.gif\" WIDTH=10 HEIGHT=1 BORDER=0 ALT=\"\"></td>.*?<TD VALIGN=\"top\"  CLASS=\"obsTextA\">(.*?)\&nbsp\;in',
		dewpoint   => '<TD VALIGN=\"top\"  CLASS=\"obsTextA\">Dew Point:<\/td>.*?<TD><IMG SRC=\"http:\/\/image\.weather\.com\/web\/blank\.gif\" WIDTH=10 HEIGHT=1 BORDER=0 ALT=\"\"></td>.*?<TD VALIGN=\"top\"  CLASS=\"obsTextA\">(.*?)<\/td>',
		visibility => '<TD VALIGN=\"top\"  CLASS=\"obsTextA\">Visibility:<\/td>.*?<TD><IMG SRC=\"http:\/\/image\.weather\.com\/web\/blank\.gif\" WIDTH=10 HEIGHT=1 BORDER=0 ALT=\"\"></td>.*?<TD VALIGN=\"top\"  CLASS=\"obsTextA\">(.*?)<\/td>',
	);

	my %data = ();

	foreach my $regexp (keys %weather) {
		if ($src =~ /$weather{$regexp}/i) {
			$data{$regexp} = $1;
			$data{$regexp} =~ s/\&deg\;/°/g;
		}
		else {
			$data{$regexp} = 'undefined';
		}
	}

	return "Current Weather for <b>$data{location}</b>\n\n"
		. "Temperature: $data{temp}\n"
		. "Feels Like: $data{feels_like}\n"
		. "UV Index: $data{uv_index}\n"
		. "Wind: $data{wind}\n"
		. "Humidity: $data{humidity}\n"
		. "Pressure: $data{pressure} in.\n"
		. "Dew Point: $data{dewpoint}\n"
		. "Visibility: $data{visibility}";
< object