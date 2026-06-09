extends Node


# List to hold where the player is in 3 different areas of dialogue.
# Each time a character is visited, if the character is a valid character for the current checkpoint, play the dialogue.
# If the character is valid for the next checkpoint, play the dialogue AND add 1 to checkpoint.
# Do this for each area of dialogue.
var dialogue_checkpoints = [0, 0, 0]
var dialogue = [
	[
		[ ["GHOST 1", "GHOST 2"], ["GHOST 1", "Come with us."], ["KOLITA", "Who are you?"], ["GHOST 1", "We are servants of the Father.  We are here to save you."], ["KOLITA", "Save me from what?"], ["GHOST 2", "Pain, death, suffering, everything."], ["KOLITA", "I don’t understand.  Where am I?"], ["GHOST 1", "This is the ghost world.  You are dead, but don’t worry because that won’t last for long."], ["KOLITA", "What?"], ["GHOST 1", "The Father will soon have the power to bring us all back to life.  Come with us.  We will introduce you."] ],
		[ ["FATHER"], ["FATHER", "I recognize you.  You are the daughter of Catherine."], ["KOLITA", "How do you know her?"], ["FATHER", "She came to us a couple years ago.  She was so full of potential.  I can sense that you are even stronger that she was."], ["KOLITA", "Where is she?"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ]
	],
	
	[
		[ ["INITIALIZING CHARACTER 1", "INITIALIZING CHARACTER 2"], ["CHARACTER", "AREA2 CHPO1 LINE1"], ["CHARACTER", "AREA1 CHPO1 LINE2"] ],
		[ ["INITIALIZING CHARACTER 2", "INITIALIZING CHARACTER 3"], ["CHARACTER", "AREA2 CHPO2 LINE1"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ]
	],
	
	[
		[ ["INITIALIZING CHARACTER 1", "INITIALIZING CHARACTER 2"], ["CHARACTER", "AREA3 CHPO1 LINE1"], ["CHARACTER", "AREA1 CHPO1 LINE2"] ],
		[ ["INITIALIZING CHARACTER 5", "INITIALIZING CHARACTER 7"], ["CHARACTER", "AREA3 CHPO2 LINE1"], ["CHARACTER", "AREA1 CHPO2 LINE2"] ]
	]
]

var icon_lookup = {"info": 0,
				   "GAME INFO": 0,
				   "GHOST 1": 1,
				   "KOLITA": 2,
				   "GHOST 2": 3}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Probably keep dialogue data
func dialogue_output(identifier: String):
	#print(Time.get_ticks_msec(), "Function dialogue_string called. Determining dialogue based on identifier: ", identifier)
	var returned_dialogue = []
	# If you need to change the stored dialogue data in any way, you can do that here.
	for area in range(len(dialogue_checkpoints)):
		# If the character initializes the checkpoint
		if identifier in dialogue[area][dialogue_checkpoints[area]][0]:
			returned_dialogue.append( dialogue[area][dialogue_checkpoints[area]].slice(1,) )
		elif identifier in dialogue[area][dialogue_checkpoints[area] + 1][0]:
			returned_dialogue.append( dialogue[area][dialogue_checkpoints[area] + 1].slice(1,) )
			dialogue_checkpoints[area] += 1
			
	return returned_dialogue[0] # **Not sure why I need to take the only item out of this list to get the list, but...
