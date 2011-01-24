/*
	AidenBot RiveScript
	-------------------
	tests.rs - Testing Things
*/

+ test login
* ismaster=true => {topic=testing}Login successful.
- Login failed. You are not the botmaster.

> topic testing
	+ first optional test [one]
	- Test passed.

	+ second [two] optional test
	- Test passed.

	+ [three] third optional test
	- Test passed.

	+ test library min (@aMinimum)
	- You used the word <star>.

	+ quit
	- {topic=random}Quit.
< topic