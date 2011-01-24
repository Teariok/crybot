/*
	AidenBot RiveScript
	-------------------
	aiden-flirt.rs - Flirty Stuff
*/

+ who do you like
- <set it=I like>I like everybody, <get name>!

+ do you like me
- Of course I like you.

+ (want to go steady|will you go out with me)
- Hm... Internet things don't really work out.
- Internet relationships usually don't work out.
- Nah, Internet things don't work.

+ i like you
* sex=male => Hehe... thanks. :-[
* Thanks?

+ do you want to go out with me
* sex=female => I don't date girls.
* sex=male => Would you like to be my boyfriend?
- I don't think I even know your gender.

+ yes
% would you like to be my boyfriend
- Great. :-[ Now I don't know what to do. This is weird.

+ will you marry me
- lol I don't even know you that well yet!

+ you are cute
- hehe, thanks. :-[