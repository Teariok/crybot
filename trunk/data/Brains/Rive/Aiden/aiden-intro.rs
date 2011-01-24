/*
	AidenBot RiveScript
	-------------------
	intro.rs - New User Interviews
*/

+ system reg new user
- Hey! I don't think we've met. My name is Aiden. What's your name?{topic=reg_name}

+ interview
- Alright, let's interview you. What's your name?{topic=reg_name}

> topic reg_name
	+ *
	- <set name={formal}<star1>{/formal}>Alright. How old are you, <get name>?{topic=reg_age}
	& if ($msg =~ / /) {
	&   $reply = "I only need your first name (or type \"quit\" to end the interview).";
	& }

	+ none
	- 500 Internal Error.
	& my ($a,$b) = split(/\-/, $id, 2);
	& $reply = "<set name=$b>Okay, I'll just call you <get name>. How old are you?{topic=reg_age}";

	+ quit
	- 500 Internal Error.
	& $reply = "<set name=$id>Okay, I'll just call you <get name>. You can tell me this stuff later then.{topic=random}";
< topic

> topic reg_age
	+ *
	- <set age=<star1>>That's cool. I'm 13. Are you a boy or a girl?{topic=reg_sex}
	& if ($msg =~ /[^0-9]/) {
	&   $reply = "I'd prefer the NUMERICAL form of your age (i.e. 13, not thirteen). How old are you?";
	& }
	& else {
	&   if ($msg > 1000) {
	&      $reply = "I doubt anyone's lived past a thousand years. How old are you?";
	&   }
	& }

	+ quit
	- Okay, you can tell me your age sometime later then.{topic=random}
< topic

> topic reg_sex
	+ boy
	- <set sex=male>Cool--I'm a boy too. Do you have any pets?{topic=reg_pets}

	+ girl
	- <set sex=female>Cool. I'm a boy. Do you have any pets?{topic=reg_pets}

	+ a boy
	@ boy
	+ i am a boy
	@ boy
	+ a guy
	@ boy
	+ a male
	@ boy
	+ male
	@ boy
	+ guy
	@ boy
	+ dude
	@ boy
	+ a dude
	@ boy

	+ a girl
	@ girl
	+ i am a girl
	@ girl
	+ a women
	@ girl
	+ a woman
	@ girl
	+ a female
	@ girl
	+ female
	@ girl
	+ woman
	@ girl
	+ women
	@ girl

	+ *
	- I need to know if you're a boy or a girl (or type "quit" to end the interview).

	+ quit
	- Okay, you can tell me later sometime.{topic=random}
< topic

> topic reg_pets
	+ yes
	- How many?{topic=reg_pet_count}

	+ no
	- Oh. Do you go to school?{topic=reg_school}

	+ *
	- I wanted to know if you have any pets. Or type "quit" to the end the interview.

	+ quit
	- Okay, interview ended.{topic=random}
< topic

> topic reg_pet_count
	+ *
	- What is its name?{topic=reg_pet_single}
	& if ($msg =~ /[^0-9]/) {
	&   $reply = "I wanted a number of pets... try again (or type quit to end the interview).";
	& }
	& else {
	&   if ($msg > 1) {
	&      $reply = "What are their names?{topic=reg_pet_many}";
	&   }
	& }

	+ quit
	- Well you can tell me later then.{topic=random}
< topic

> topic reg_pet_single
	+ *
	- <set pet={formal}<star1>{/formal}>That's a cool name. Do you go to school?{topic=reg_school}

	+ quit
	- Okay, interview ended.{topic=random}
< topic

> topic reg_pet_many
	+ *
	- <set pet={formal}<star1>{/formal}>Those are cool names. Do you go to school?{topic=reg_school}

	+ quit
	- Okay, interview ended.{topic=random}
< topic

> topic reg_school
	+ yes
	- What class is your favorite?{topic=reg_class}

	+ no
	- Oh. Well this is the end of the interview. What's up?{topic=random}

	+ quit
	@ no

	+ *
	- Yes or no: do you go to school?
< topic

> topic reg_class
	+ *
	- That sounds like a fun class. Anyway, this is the end of the interview. What's up?{topic=random}
< topic