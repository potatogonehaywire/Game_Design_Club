extends Node


# List to hold where the player is in 3 different areas of tutorial.
# Each time a character is visited, if the character is a valid character for the current checkpoint, play the tutorial.
# If the character is valid for the next checkpoint, play the tutorial AND add 1 to checkpoint.
# Do this for each area of tutorial.
var tutorial_checkpoints = [0, 0, 0]
var tutorial_data = {
	"INTERACT": "Click on characters and objects to interact.",
	"MOVE": "Use WASD to move around."
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Probably keep tutorial data
func tutorial_output(identifiers: Array):
	var returned_tutorials = []
	for identifier in identifiers:
		returned_tutorials.append(tutorial_data[identifier])
	return returned_tutorials
