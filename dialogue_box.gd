# NOTES:
# THIS ENTIRE SCENE (not node) SHOULD BE A CHILD OF THE PLAYER SCENE.
# I've put an instance into the player scene already, but it may fail if you try to use it outside of that.
# Actual dialogue messages should be stored in DialogueData.

extends Node2D



var current_dialogue = [["GAME INFO", "Placeholder for dialogue box text."], ["GAME INFO", "Click on godot logo in map to get only currently added dialogue."]]
var current_line = -1

var dialogue_section_needs_update = true

const GUI_HELP_INFO = "[J] Back  [K] Next"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("message", message) # Enables messaging with the player.
	$DialogueText.text = str(current_dialogue[current_line])
	$DialogueIcon.animation = "26-05-04 sprites v1"
	$DialogueIcon.frame = $DialogueData.icon_lookup["info"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dialogue_next") or dialogue_section_needs_update:
		if current_line < len(current_dialogue) - 1:
			current_line += 1
	if Input.is_action_just_pressed("dialogue_last"):
		if current_line > 0:
			current_line -= 1
	
	if Input.is_action_just_pressed("dialogue_last") or dialogue_section_needs_update or Input.is_action_just_pressed("dialogue_next"):
		var correct_dialogue_text = str(current_dialogue[current_line][0]) + "\n" + str(current_dialogue[current_line][1])
		correct_dialogue_text += "\n" + GUI_HELP_INFO
		if current_line == len(current_dialogue) - 1:
			correct_dialogue_text += "\n(!) End of available dialogue"
		
		$DialogueText.text = correct_dialogue_text
		$DialogueIcon.frame = $DialogueData.icon_lookup[current_dialogue[current_line][0]]
		
		dialogue_section_needs_update = false
	



func message(msg: Array):
	if msg[0]["recipient"] == "dialogue scene":
		if msg[0]["topic"] == "start dialogue":
			if current_dialogue != $DialogueData.dialogue_output(msg[1][0]):
				current_dialogue = $DialogueData.dialogue_output(msg[1][0])
				current_line = -1
				dialogue_section_needs_update = true
		else:
			print("Dialogue scene received message, formatting incorrect or code missing.")
