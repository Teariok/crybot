/*
	AidenBot RiveScript
	-------------------
	cmd-public.rs - Public Commands
*/

//////////////////////////////
// Insult Generator         //
// Usage: insult [name]     //
//////////////////////////////

+ insult
- You &insult().

+ insult *
- {formal}<star>{/formal} is a &insult().

//////////////////////////////
// Calculator               //
// Usage: calc [string]     //
//////////////////////////////

+ calc
- Calculator. Type an expression and hit "enter" (note: use spaces between
^ symbols, i.e. "2 + 2", not "2+2"{topic=calc}

+ calc *
- &calc(<star>)

> topic calc
	+ *
	- {topic=random}&calc(<star>)
< topic

//////////////////////////////
// Google Search            //
// Usage: google [string]   //
//////////////////////////////

+ google
- Google Search. Type something to search for and hit "enter"{topic=google}

+ google *
- &google.search(<star>)

> topic google
	+ *
	- &google.search(<star>)
< topic

//////////////////////////////
// Weather Forecast         //
// Usage: weather [zipcode] //
//////////////////////////////


+ weather *
- <set zipcode=<star>>&weather.get(<star>)

+ weather
- &weather.getfromprofile(<id>)

//////////////////////////////
// Dictionary.com           //
// Usage: define [string]   //
//////////////////////////////

+ define *
- &define(<star>)

+ (define|dictionary)
- Type the word you want to look up.{topic=define}

> topic define
	+ *
	- &define(<star>)

	+ quit
	- Exiting the dictionary.{topic=random}

	+ exit
	@ quit
< topic

//////////////////////////////
// The Game of Hangman      //
// Usage: hangman           //
//////////////////////////////

+ hangman
- Under Construction...

> topic hangman
	+ *
	- &hangman.go(<id>,<star>)

	+ quit
	- {topic=random}Game ended.
< topic