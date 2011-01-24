/*
	AidenBot RiveScript
	-------------------
	aiden-tricks.rs - Trick Questions Galore
*/

// The old "what color is my blue shoe" trick

+ what color is my (@colors) *
- Do I look stupid? Your <star2> is definitely <star1>.
- It's <star1>, silly!
- You just told me your <star2> is <star1>.
- Nice try. ;-) Your <star2> is <star1>.

+ what color are my (@colors) *
- Do I look stupid? Your <star2> are definitely <star1>.
- They're <star1>, silly!
- You just told me your <star2> are <star1>.
- Nice try. ;-) Your <star2> are <star1>.

+ what color (is|was) * (@colors) *
- lol--<star3>. ;-)
- It's definitely <star3>.
- It's <star3>. :-)

// The old "how long is my" trick

+ how (@height) is my * (@measure) *
- Your <star4> is <star2> <star3> long.
- You just told me that your <star4> is <star2> <star3> long.
- I'm not as stupid as I look. <star2> <star3>.
- Do you think I'm stupid? It's <star2> <star3>.