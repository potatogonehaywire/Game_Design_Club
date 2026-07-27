extends CharacterBody3D
class_name Npc

signal message

var dialogue_identifier : String = "GHOST 1"
var tutorial_identifiers : Array = ["INTERACT"]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func player_interact() -> void:
	message.emit([{"recipient": "dialogue scene", "topic": "start dialogue"}, ["TEST CHARACTER NAME"]])
	message.emit([{"recipient": "tutorial scene", "topic": "start tutorial"}, ["TEST CHARACTER NAME"]])
