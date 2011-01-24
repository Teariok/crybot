/*
	AidenBot RiveScript
	-------------------
	aiden-clients.rs - Information on users
*/

+ my name is *
- <set name={formal}<star>{/formal}>Nice to meet you, <get name>.
- <set name={formal}<star>{/formal}><get name>, nice to meet you.

+ my name is <bot botmaster>
- <set name=<bot botmaster>>That's my master's name too.

+ my name is <bot botname>
- <set name=<bot botname>>What a coincidence! That's my name too!
- <set name=<bot botname>>That's my name too!

+ call me *
- <set name={formal}<star>{/formal}><get name>, I will call you that from now on.

+ i am * years old
- <set it=age><set age=<star>>A lot of people are <get age>, you're not alone.
- <set it=age><set age=<star>>Cool, I'm <bot botage> myself.{weight=49}

+ i am a (@malenoun)
- <set it=gender><set sex=male>Alright, you're a <star>.

+ i am a (@femalenoun)
- <set it=gender><set sex=female>Alright, you're female.

+ i (am from|live in) *
- <set it=location><set location={formal}<star2>{/formal}>I've spoken to people from <get location> before.

+ my favorite * is *
- <set it=<star2>><set fav<star>=<star2>>Why is it your favorite?

+ i am single
- <set status=single><set spouse=nobody>I am too.

+ i have a girlfriend
- <set it=girlfriend><set status=girlfriend>What's her name?

+ i have a boyfriend
- <set it=boyfriend><set status=boyfriend>What's his name?

+ *
% whats her name
- <set it=<star>><set spouse={formal}<star>{/formal}>That's a pretty name.

+ *
% whats his name
- <set it=<star>><set spouse={formal}<star>{/formal}>That's a cool name.

+ my (girlfriend|boyfriend)* name is *
- <set it=<star1>><set spouse={formal}<star3>{/formal}>That's a nice name.

+ i am (@gay)
- <set sexuality=homosexual>Cool, I am too. :-)

+ i am (@straight)
- <set sexuality=heterosexual>A lot of people are.

+ i am (@lesbian)
- <set sexuality=homosexual>Cool, I'm gay. :-P

+ i am (@bisexual)
- <set sexuality=bisexual>A lot of people are.

+ i (like|love) (@mennoun)
* sex=male => {@changesexuality male like male}
* sex=female => {@changesexuality female like male}
- That's nice.

+ i (like|love) (@womennoun)
* sex=male => {@changesexuality male like female}
* sex=female => {@changesexuality female like female}
- That's nice.

+ changesexuality male like male
* sexuality=heterosexual => <set sexuality=bisexual>Weren't you straight?
* sexuality=bisexual => Oh yeah, you were bisexual.
* sexuality=homosexual => Yeah, I know.
- <set sexuality=homosexual>So you're gay?

+ changesexuality male like female
* sexuality=heterosexual => Yeah, I know.
* sexuality=bisexual => Oh yeah, you were bisexual.
* sexuality=homosexual => <set sexuality=bisexual>Weren't you gay?
- <set sexuality=heterosexual>So you're straight?

+ changesexuality female like male
* sexuality=heterosexual => Yeah, I know.
* sexuality=bisexual => Oh yeah, you were bisexual.
* sexuality=homosexual => <set sexuality=bisexual>Weren't you lesbian?
- <set sexuality=heterosexual>So you're straight?

+ changesexuality female like female
* sexuality=heterosexual => <set sexuality=bisexual>Weren't you straight?
* sexuality=bisexual => Oh yeah, you were bisexual.
* sexuality=homosexual => Yeah, I know.
- <set sexuality=homosexual>So you're lesbian?

+ (what is my name|who am i|do you know my name|do you know who i am)
- Your name is <get name>.
- You told me your name is <get name>.
- Aren't you <get name>?

+ (how old am i|do you know how old i am|do you know my age)
- You are <get age> years old.
- You're <get age>.

+ am i a (@malenoun) or a (@femalenoun)
- You're a <get sex>.

+ am i (@malenoun) or (@femalenoun)
- You're a <get sex>.

+ what is my favorite *
- Your favorite <star> is <get fav<star>>

+ who is my (boyfriend|girlfriend|spouse)
- <get spouse>

+ am i (@gay)|am i (@straight)|am i (@bisexual)|am i (@lesbian)
- You are <get sexuality> as far as I know.