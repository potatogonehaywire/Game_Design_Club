extends Node


# List to hold where the player is in 3 different areas of dialogue.
# Each time a character is visited, if the character is a valid character for the current checkpoint, play the dialogue.
# If the character is valid for the next checkpoint, play the dialogue AND add 1 to checkpoint.
# Do this for each area of dialogue.
var dialogue_checkpoints : Array = [0, 0, 0]

# dictionary to convert dialogue checkpoints into quests
# first key is for the dialogue area
#he value of dialogue_checkpoints[area] will be the index of the quest inside the list
# {area : [{"quest_name" : name, "quest_description" : desc , "return_text" : text}, {"quest_name" : name, "quest_description" : desc , "return_text" : text}]
var dialogue_to_quest : Dictionary = {
	0 : [{"quest_name" : "Kick the shelf", "quest_description": " Organize the Shelves", "return_text": "none"},{"quest_name" : "talk to father", "quest_description": "", "return_text": "none"},{"quest_name" : "talk to ghost 3", "quest_description": "", "return_text": "none"}]
	, 1 : [{"quest_name" : "Talk to ghost", "quest_description": " Organize the Shelves", "return_text": "none"},{"quest_name" : "talk to father", "quest_description": "", "return_text": "none"},{"quest_name" : "talk to ghost 3", "quest_description": "", "return_text": "none"}]
	}
	
var dialogue : Array = [
	[
		# Prologue
		[ ["SHELF"], 
		["", "Kolita is shelving cans on a shelf in a grocery store."], 
		["", "Kolita used to dream of becoming a doctor.  Funny how these things change."], 
		["BOSS", "Kolita!  I need you to change the sign outside for me!"], 
		["KOLITA", "Alright boss."], 
		["KOLITA", "Save me from what?"], 
		["", "Kolita had it all, loving parents, good friends, and a sister named Issac. This all changed when her mother got sick."], 
		["", "Over the next few months, she withered away until there was nothing left.  None of the treatments did anything but plunge the family deeper and deeper into debt."], 
		["", "Now Kolita is stuck shelving cans in a store to try to pay off some of that debt."], 
		["", "Life is fragile, isn’t it?  We always assume we are immortal until we see death staring us in the face.  Sometimes we don’t see it coming."], 
		["", "At least this family no longer needs to waste money feeding another mouth."] ],
	],
	
	[	
		# Act 1 Scene 1
		[ ["DOVE"], 
		["DOVE", "How unfortunate.  You had so much ahead of you.  Too bad, I guess."], 
		["KOLITA", "What is going on here?  Where am I?"], 
		["DOVE", "You don’t get it do you?  How sad."], 
		["KOLITA", "You can’t be real!  Birds don't talk!"], 
		["DOVE", "Gah!  How rude!"]],
		
		[["COWBOY"], ["COWBOY", "Oh great, it did it again.  Don't worry, you are safe now."]]
	],
	
	
	[
		# Act 1 Scene 2
		[ ["COWBOY", "FOOTBALLER"], 
		["COWBOY", "Don’t be scared.  You are safe here."], 
		["KOLITA", " Who are you people?  Where am I?"], 
		["FOOTBALLER", " You are dead.  This is our afterlife."], 
		["KOLITA", "What?"], 
		["FOOTBALLER", " I am sorry to inform you that you died.  Now come with me."]],
		
		[ ["FATHER"], 
		["FATHER", "I take it you are our newest member.  It is nice having you with us.  Say, you seem kind of familiar to me."],
		["KOLITA", "Who are you?"], 
		["FATHER", "I am the Father.  My job is to care for all of my children here until we can return to the living world.  Would you care to join me?"],
		["KOLITA", "I…"],
		["FATHER", "Don’t worry.  You don’t need to answer me just yet.  Why don’t you rest here for a while?"],
		["FATHER", " This is the only safe place in this realm.  Most of the ghosts outside of here are hostile and will try to absorb your essence."],
		["KOLITA", "Is this… for real?"],
		["FATHER", "If you are talking about death, then yes.  Do not worry though.  I will make sure you make it home."],
		["KOLITA", "How?"],
		["FATHER", "Have you ever heard about Nessie?"],
		["KOLITA", "It’s a myth my mother told me when I was young."],
		["FATHER", "I beg to differ.  The fact that you have heard of it proves its existence.  It has the power to bring people back to life."],
		["FATHER", "If we can gather enough combined strength, then we can take that power to all return to our world."],
		["KOLITA", "..."],
		["FATHER", " I know this must be a lot to take in.  Why don’t you rest for a bit first.  I’ll have one of my children give you a tour around our village."]]
	],
	
	[	# Act 1 Scene 3
		[ ["COWBOY"], 
		["COWBOY", "Now this is where we go to unwind.  We have fun games like rock paper scissors and tik tac toe.  Don’t worry, death isn’t as boring as it sounds."],
		["COWBOY", "Over there is our grocery store.  You can’t buy anything because we can’t eat.  They are just a bunch of painted rocks.  It is where you go when you want a nostalgic walk down memory lane."],
		["KOLITA", "What is the point of any of this?"],
		["COWBOY", "It makes our world a happier place.  Whatever that means."]],
		
		[ ["COWBOY"], 
		["KOLITA", "Why am I like this?  Why am I not like you?"],
		["COWBOY", "Its because your spirit is still fresh.  You'll convert soon enough."],
		["KOLITA", " Why is the father human as well?"],
		["COWBOY", "He is so powerful that he was able to revert back."],
		["COWBOY", "It sounds bad becoming a monster, but it actually feels kind of refreshing. Its like pouring some Sprite over your head during a hot day."],
		["KOLITA", "That sounds sticky."],
		["COWBOY", "On the bright-side, you are lucky you survived contempt Nessie.  And soon, you will get to return home.  You are incredibly lucky."],
		["KOLITA", "I wouldn't call death lucky.  When do I get to be resurrected anyway?"],
		["COWBOY", "Whenever we manage to defeat all three of Nessie's remaining forms."],
		["KOLITA", "And when will that be?"],
		["COWBOY", "We defeated the happiness form long before I got here.  The Father has its essence now."],
		["COWBOY", "The next one will probably be the contempt form, given how much trouble it has been causing us."],
		["KOLITA", "When will that be?"],
		["COWBOY", "Whenever the Father says we have the strength.  We have already lost so many trying to defeat it.  Your mother was one of them."],
		["KOLITA", "What? You can’t be serious!"],
		["COWBOY", "She joined our family so that she could get back to you. You both had the same fire… please promise me that you will be careful."],
		["KOLITA", "You can’t be serious!"]]
		
	],
	
	[ #ACT 1 SCENE 4
		[ ["DOVE"],
		["KOLITA", "Why did you do this to me?  Why did you take me from my family?"]],
		
		[["DOVE"],
		["KOLITA", "What are you?  Why did you help me?"]],
		
		[["GHOST"],
		["GHOST", "Gah, contempt Nessie did it again!  If only I still had my flamethrower, then I could get us past."],
		["GHOST", "But a bunch of evil ghosts stole it from me.  I guess I'll just go cut down some more trees while I wait to be rescued."]],
		
		[["CONTEMPT_DOVE"],
		["DOVE", "Oh, come on, don’t tell me that you are going to destroy my beautiful self-portrait!"],
		["DOVE", "Listen now, that cult over there is nothing but trouble.  That wretched \"father\" is just scamming people into feeding him power."],
		["KOLITA", "You lie!  You killed my mother!"],
		["DOVE", "You know, you have some semblance of potential.  I'll cut you a deal."],
		["DOVE", "Normally I'd just swoop in and destroy that sucker, but he used to power of my brother and his followers to keep me out."],
		["DOVE", "But if you kill him for me, I'll resurrect your body and bring back your mother."],
		["KOLITA", "That’s impossible!"],
		["DOVE", "Her essence is inside of me, I could bring her back.  All you need is one good swing of your spear."],
		["KOLITA", "Stop lying to me!"]],
		
		[["CONTEMPT_DOVE"],
		["DOVE", " Gah!  I'll get you for this!  And don't you dare touch that portrait!"]]
	],
	
	[ # ACT 1 SCENE 5
		[["FATHER"],
		["FATHER", "I can't believe it… how is this possible?"],
		["FATHER", "You see the contempt heart that you are carrying?  You can't break it open to extract its power by yourself."],
		["FATHER", "Give it to me."],
		["KOLITA", " I didn't do this for you."],
		["FATHER", "Don't…"],
		["FATHER", "Fine."],
		["FATHER", "Whatever."],
		["FATHER", "I am disappointed by your sins of greed, but I cannot save you."],
		["KOLITA", "I am going to use this power to defeat the other forms and then you can have it."],
		["FATHER", " You can't use it until you break it open.  There is no point in not giving me it."],
		["KOLITA", " I don't care.  Just tell me where the love form is."],
		["FATHER", "Fine, it is to the north."],
		["KOLITA", " Thank you.  I'll be back soon."]],
		
		[["FOOTBALLER"],
		["FOOTBALLER", "What are you doing?  How dare you disrespect the father like that!"],
		["KOLITA", "The power is mine, not his."],
		["FOOTBALLER", "You aren't going to be able to use that heart.  All it will do is make you mad."],
		["KOLITA", "I don't care."],
		["FOOTBALLER", "Give that to me!"],
		]
	]
]

var correct_area : int = 0

#var icon_lookup : Dictionary = {"info": 0,
				   #"GAME INFO": 0,
				   #"GHOST 1": 1,
				   #"KOLITA": 2,
				   #"GHOST 2": 3}


# Probably keep dialogue data
func dialogue_output(identifier: String) -> Array:
	#print(Time.get_ticks_msec(), "Function dialogue_string called. Determining dialogue based on identifier: ", identifier)
	var returned_dialogue : Array = []
	var found_correct_dialogue : bool = false
	# If you need to change the stored dialogue data in any way, you can do that here.
	#for area : int in range(len(dialogue_checkpoints)):
	# if the player hasn't played through all the dialogue 
	if len(dialogue[correct_area]) > dialogue_checkpoints[correct_area]:
		# if the player talks to the character in the right order
		if identifier in dialogue[correct_area][dialogue_checkpoints[correct_area]][0]:
			returned_dialogue.append( dialogue[correct_area][dialogue_checkpoints[correct_area]].slice(1,) )
			dialogue_checkpoints[correct_area] += 1
			found_correct_dialogue = true
	else:
		correct_area += 1
		
	# return empty dialogue if the player talks to the wrong person
	if !found_correct_dialogue:
		returned_dialogue = [[["" , ""]]]
		#elif identifier in dialogue[area][dialogue_checkpoints[area] + 1][0]:
			#returned_dialogue.append( dialogue[area][dialogue_checkpoints[area] + 1].slice(1,) )
			#dialogue_checkpoints[area] += 1
			
	return returned_dialogue[0] # **Not sure why I need to take the only item out of this list to get the list, but...

func set_quest() -> Dictionary:
	print("set Quest", correct_area)
	print(dialogue_to_quest[correct_area][dialogue_checkpoints[correct_area] - 1])
	return dialogue_to_quest[correct_area][dialogue_checkpoints[correct_area] - 1]
