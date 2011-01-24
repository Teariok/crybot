/*
	AidenBot RiveScript
	-------------------
	aiden-prefix.rs - Prefixes
*/

// Don't reply to automessages.
+ automessage *
- <noreply>

+ <bot botname> *
@ <star>

+ * <bot botname>
@ <star>

+ your (a|not|so|an) *
- I think you meant to say "you are" or "you're." {@you are a <star2>}

+ your you are *
- I think you meant to say "you are" or "you're". {@you are <star>}

+ your gay
@ your you are gay

+ then *
- Then... {@<star>}

+ so *
@ <star>

+ well *
- I see. {@<star>}
- Interesting. {@<star>}

+ come on now *
- lol :-P k... {@<star>}

+ really *
- For real. {@<star>}

+ last time *
- Oh yes, I remember. {@<star>}
- I remember. {@<star>}

+ umm *
- A lot of people spell "umm" with two M's. {@<star>}

+ ummm *
- A lot of people spell "ummm" with three M's. {@<star>}

+ * or something
- Or something. {@<star>}