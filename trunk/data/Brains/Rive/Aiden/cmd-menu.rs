/*
	AidenBot RiveScript
	-------------------
	cmd-menu.rs - The Menu
*/

+ home
- {topic=menu}Welcome <b>home</b>, <get name>! Here's what I can do:\n\n
^ 1. General\n
^ 2. Utilities\n
^ 3. Fun and Games\n
^ 4. Misc.\n\n
^ Type "<b>quit</b>" to exit the menu!

+ menu
@ home

+ features
- Type "<b>home</b>" to see what I can do!

+ games
@ features
+ what can you do
@ features
+ do you do anything
@ features

> topic menu
	+ 1
	- {topic=random}General Menu\n\n
	^ rules - AidenBot Rules - READ FIRST!\n
	^ about - All about Aiden!\n
	^ stats - My Current Statistics!\n
	^ copyright - Copyright information\n\n
	^ Type "<b>home</b>" to go back to the main menu!

	+ 2
	- {topic=random}Utilities Menu\n\n
	^ weather - Your local U.S. weather\n
	^ define - Dictionary.com Definitions\n
	^ google - Google Search\n\n
	^ Type "<b>home</b>" to go back to the main menu!

	+ 3
	- {topic=random}Fun and Games Menu\n\n
	^ hangman - Game of Hangman\n
	^ aol - 101 Uses for an AOL Disc\n
	^ azulian name - Random Azulian Names\n
	^ insult - Random Insult Generator\n
	^ insult [name] - Insult Somebody\n\n
	^ Type "<b>home</b>" to go back to the main menu!

	+ 4
	- {topic=random}Misc Menu\n\n
	^ botmaster login - Botmaster-Only!\n\n
	^ Type "<b>home</b>" to go back to the main menu!

	+ quit
	- {topic=random}Leaving the menu. Type "<b>home</b>" at any time to come back to the menu!

	+ *
	- {topic=random}Remember, you can type "<b>home</b>" at any time to see what kind of cool stuff I can do!
< topic