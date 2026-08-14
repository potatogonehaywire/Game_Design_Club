extends Node


# List to hold where the player is in 3 different areas of dialogue.
# Each time a character is visited, if the character is a valid character for the current checkpoint, play the dialogue.
# If the character is valid for the next checkpoint, play the dialogue AND add 1 to checkpoint.
# Do this for each area of dialogue.
var dialogue_checkpoints : Array = [0, 0, 0]

# dictionary to convert dialogue checkpoints into quests
# first key is for the dialogue area
#he value of dialogue_checkpoints[area] will be the index of the quest inside the list
var dialogue_to_quest : Dictionary = {
	0 : [{"quest_name" : "Organize the Shelves", "quest_description": " Organize the Shelves", "return_text": "none"}]
	, 1 : [{"quest_name" : "Talk to father", "quest_description": " Organize the Shelves", "return_text": "none"}, {"quest_name" : "Talk to father", "quest_description": " Organize the Shelves", "return_text": "none"}]
	}
	
var dialogue : Array = [
	
	[
		[ ["GHOST 1", "GHOST 2"], ["GHOST 1", "Come with us."], ["KOLITA", "Who are you?"], ["GHOST 1", "We are servants of the Father.  We are here to save you."], ["KOLITA", "Save me from what?"], ["GHOST 2", "Pain, death, suffering, everything."], ["KOLITA", "I don’t understand.  Where am I?"], ["GHOST 1", "This is the ghost world.  You are dead, but don’t worry because that won’t last for long."], ["KOLITA", "What?"], ["GHOST 1", "The Father will soon have the power to bring us all back to life.  Come with us.  We will introduce you."] ],
		[ ["FATHER"], ["FATHER", "I recognize you.  You are the daughter of Catherine."], ["KOLITA", "How do you know her?"], ["FATHER", "She came to us a couple years ago.  She was so full of potential.  I can sense that you are even stronger that she was."], ["KOLITA", "Where is she?"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ],
		[["COWBOY"], ["COWBOY", "Damn, you need new sheets."], ["KOLITA", "What are you on?"]]
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
	for area : int in range(len(dialogue_checkpoints)):
		# if the player hasn't played through all the dialogue 
		if len(dialogue[area]) > dialogue_checkpoints[area]:
			# if the player talks to the character in the right order
			if identifier in dialogue[area][dialogue_checkpoints[area]][0]:
				returned_dialogue.append( dialogue[area][dialogue_checkpoints[area]].slice(1,) )
				dialogue_checkpoints[area] += 1
				found_correct_dialogue = true
		
		# return empty dialogue if the player talks to the wrong person
		if !found_correct_dialogue:
			returned_dialogue = [[["" , ""]]]
		#elif identifier in dialogue[area][dialogue_checkpoints[area] + 1][0]:
			#returned_dialogue.append( dialogue[area][dialogue_checkpoints[area] + 1].slice(1,) )
			#dialogue_checkpoints[area] += 1
			
	return returned_dialogue[0] # **Not sure why I need to take the only item out of this list to get the list, but...
