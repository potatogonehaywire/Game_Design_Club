extends Node


# List to hold where the player is in 3 different areas of tutorial.
# Each time a character is visited, if the character is a valid character for the current checkpoint, play the tutorial.
# If the character is valid for the next checkpoint, play the tutorial AND add 1 to checkpoint.
# Do this for each area of tutorial.
var tutorial_checkpoints : Array = [0, 0, 0]
var tutorial_data : Dictionary = {
	"INTERACT": "Click on characters and objects to interact.",
	"MOVE": "Use WASD to move around."
}

# Probably keep tutorial data
func tutorial_output(identifiers: Array) -> Array:
	var returned_tutorials : Array = []
	for identifier in identifiers:
		returned_tutorials.append(tutorial_data[identifier])
	return returned_tutorials
