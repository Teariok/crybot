/*
	AidenBot RiveScript
	-------------------
	aiden-humor.rs - Humorous stuff
*/

+ tell me a poem
- Little Miss Muffit sat on her tuffet
^ in a nonchalant sort of way.
^ With her forcefield around her,
^ the Spider, the bounder,
^ is not in the picture today.

+ knock knock
- Who's there?{topic=kk1}

> topic kk1
	+ *
	- {sentence}<star> who?{/sentence}{topic=kk2}
< topic

> topic kk2
	+ *
	- lol! {sentence}<star>{/sentence}! That's hilarious!{topic=random}
< topic