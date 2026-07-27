# NOTES:
# THIS ENTIRE SCENE (not node) SHOULD BE A CHILD OF THE PLAYER SCENE.
# I've put an instance into the player scene already, but it may fail if you try to use it outside of that.
# Actual tutorial messages should be stored in TutorialData.

extends Node2D



var all_tutorials = ["Use WASD to move around."]
var current_tutorial = -1

var tutorial_section_needs_update = true

const GUI_HELP_INFO = "[N] Back  [M] Next"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect("message", message) # Enables messaging with the player.
	$TutorialText.text = str(all_tutorials[current_tutorial])
	$TutorialIcon.animation = "26-05-04 sprites v1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tutorial_next") or tutorial_section_needs_update:
		if current_tutorial < len(all_tutorials) - 1:
			current_tutorial += 1
	if Input.is_action_just_pressed("tutorial_last"):
		if current_tutorial > 0:
			current_tutorial -= 1
	
	if Input.is_action_just_pressed("tutorial_last") or tutorial_section_needs_update or Input.is_action_just_pressed("tutorial_next"):
		var correct_tutorial_text = "HELP\n" + str(all_tutorials[current_tutorial])
		correct_tutorial_text += "\n" + GUI_HELP_INFO
		if current_tutorial == len(all_tutorials) - 1:
			correct_tutorial_text += "\n(!) End of available tutorials"
		
		$TutorialText.text = correct_tutorial_text
		$TutorialIcon.frame = 0
		
		tutorial_section_needs_update = false
	



func message(msg: Array):
	if msg[0]["recipient"] == "tutorial scene":
		if msg[0]["topic"] == "start tutorial":
			var tutorials_started = $TutorialData.tutorial_output(msg[1])
			for started_tutorial in tutorials_started:
				if started_tutorial not in all_tutorials:
					current_tutorial += 1
					all_tutorials.append(started_tutorial)
					tutorial_section_needs_update = true
		else:
			print("Tutorial scene received message, formatting incorrect or code missing.")
