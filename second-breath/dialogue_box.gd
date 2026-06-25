# NOTES:
# THIS ENTIRE SCENE (not node) SHOULD BE A CHILD OF THE PLAYER SCENE.
# I've put an instance into the player scene already, but it may fail if you try to use it outside of that.
# Actual dialogue messages should be stored in DialogueData.

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("message", _message) # Enables messaging with the player.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _message(message: Array):
	if message[0]["recipient"] == "dialogue scene":
		if message[0]["topic"] == "start dialogue":
			print("Request to start dialogue received.")
			print("Dialogue identifier:")
			print(message[1][0])
			$DialogueText.text = $DialogueData._dialogue_string(message[1][0])
		else:
			print("Dialogue scene received message, formatting incorrect or code missing.")
