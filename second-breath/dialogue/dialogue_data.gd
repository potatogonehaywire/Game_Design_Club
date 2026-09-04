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
		[ ["GHOST 2"], ["FATHER", "Oh it's you again"], ["KOLITA", "How do you know her?"], ["FATHER", "She came to us a couple years ago.  She was so full of potential.  I can sense that you are even stronger that she was."], ["KOLITA", "Where is she?"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ],
		[ ["INITIALIZING CHARACTER 2", "INITIALIZING CHARACTER 3"], ["CHARACTER", "AREA2 CHPO2 LINE1"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ]
	],
	
	[
		[ ["INITIALIZING CHARACTER 1", "INITIALIZING CHARACTER 2"], ["CHARACTER", "AREA3 CHPO1 LINE1"], ["CHARACTER", "AREA1 CHPO1 LINE2"] ],
		[ ["INITIALIZING CHARACTER 5", "INITIALIZING CHARACTER 7"], ["CHARACTER", "AREA3 CHPO2 LINE1"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ]
	],
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
