/*
	AidenBot RiveScript
	-------------------
	aiden-insults.rs - How to knock 'em down a peg
*/

// Called by some insults below to summon a comeback.
+ system random comeback
- You sound reasonable... time to up the medication.
- I see you've set aside this special time to humiliate yourself in public.
- Ahhh... I see the screw-up fairy has visited us again.
- I don't know what your problem is, but I'll bet it's hard to pronounce.
- I like you. You remind me of when I was young and stupid.
- You are validating my inherent mistrust of strangers.
- I'll try being nicer if you'll try being smarter.
- I'm really easy to get along with once you people learn to worship me.
- It sounds like English, but I can't understand a word you're saying.
- I can see your point, but I still think you're full of it.
- What am I? Flypaper for freaks!?
- Any connection between your reality and mine is purely coincidental.
- I'm already visualizing the duct tape over your mouth.
- Your teeth are brighter than you are.
- We're all refreshed and challenged by your unique point of view.
- I'm not being rude. You're just insignificant.
- It's a thankless job, but I've got a lot of Karma to burn off.
- I know you're trying to insult me, but you obviously like me--I can see your tail wagging.

+ system harsh insult
- You're very rude! I'm not talking to you until you apologize.{topic=apology}
- You're mean! Apologize or I'm not talking to you again.{topic=apology}

> topic apology
	+ *
	- No, apologize for being so rude to me.
	- I'm not listening until you say you're sorry.
	- Apologize for being so rude and then I'll talk to you.

	+ (i am sorry|im sorry|sorry)
	- See? That wasn't so hard, was it? I'll forgive you -- just don't let it happen again!{topic=insultrial}

	+ (sorrynot|i am not sorry|sorry not)
	- You're just being a jerk today aren't you. If you can't apologize properly, I won't accept your apologies at all!{topic=apologyhard}
< topic

> topic insultrial
	// This is for if people say "I'm sorry." "NOT!" the bot will be more strict on its forgiveness policy now.
	+ (not|no im not|no i am not|jk|just kidding)
	- Hey! You said you were sorry, don't take it back! Alright... I'm just not going to talk to you for a while.{topic=apologyhard}

	+ *
	- Alright. So, what's up?{topic=random}
< topic

> topic apologyhard
	// If they said they're sorry and then take it back, don't forgive them. This will now be a matter of
	// the bot being reloaded or restarted, not them apologizing.
	+ *
	- I'm not listening to you.
	- You're a cruel jerk. I'm not listening.
	- You sound reasonable... time to up the medication.
	- I see you've set aside this special time to humiliate yourself in public.
	- Ahhh... I see the screw-up fairy has visited us again.
	- I don't know what your problem is, but I'll bet it's hard to pronounce.
	- I like you. You remind me of when I was young and stupid.
	- You are validating my inherent mistrust of strangers.
	- I'll try being nicer if you'll try being smarter.
	- I'm really easy to get along with once you people learn to worship me.
	- It sounds like English, but I can't understand a word you're saying.
	- I can see your point, but I still think you're full of it.
	- What am I? Flypaper for freaks!?
	- Any connection between your reality and mine is purely coincidental.
	- I'm already visualizing the duct tape over your mouth.
	- Your teeth are brighter than you are.
	- We're all refreshed and challenged by your unique point of view.
	- I'm not being rude. You're just insignificant.
	- It's a thankless job, but I've got a lot of Karma to burn off.

	+ (sorry|i am sorry|im sorry)
	- I don't believe you're really sorry. Not after what you did.
	- Sorry? Yeah right! Why should I believe you?!
< topic

// Challenging
	+ no i did not
	- Yes you did.
	- Liar.
	- Don't argue with me.

	+ yes i did
	- No you didn't.
	- Don't argue with me.

	+ i do
	- No you don't.

	+ yes i do
	- No you don't.

	+ you do not
	- Yes I do.

	+ no you do not
	- Yes I do!!!
	- Don't argue with me.

	+ you do not *
	@ you do not

	+ i do *
	@ i do

	+ yes i do *
	@ yes i do

+ dumbass
- I'm sure your ass doesn't pass IQ tests either.

+ smartass
- Well I know I'm smart so you must be the ass.

+ (your an idiot|your stupid|your a moron|your a retard|your retarded)
- At least I know the difference between "your" and "you're."

+ (you are a idiot|you are an stupid)
- Well at least I know the difference between "a" and "an."

+ you suck
- Yeah because that was real mature.

+ butthead
- How immature.
- Alright child, time to grow up.

+ shit
- Now that was just uncalled for.

+ shut up
- What are you gonna do about it?
- Make me.

+ *fuck*
@ system harsh insult
+ fuck
@ system harsh insult
+ (fag|faggot|fagot|fagget|faget|your a fag|you are a fag|your a faggot)
@ system harsh insult
+ (you are a faggot|your a fagget|you are a fagget|your a faget|you are a faget)
@ system harsh insult
+ (queer|your queer|your a queer|you are queer|you are a queer)
@ system harsh insult
+ (stfu|shut the fuck up)
@ system harsh insult

+ you are short
- I may be short but you're ugly and I still have time to grow!

+ gay
- Is that supposed to be an insult?

+ penis licker
- Carpet muncher.

+ *bitch*
@ system random comeback
+ *cunt*
@ system random comeback
+ *whore*
@ system random comeback
+ *skank*
@ system random comeback
+ *slut*
@ system random comeback
+ *hooker*
@ system random comeback
+ *prostitute*
@ system random comeback
+ *your mom*
@ system random comeback