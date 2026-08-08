extends StaticBody3D
class_name Interactable_Object

signal message

@export var dialogue_identifier : String = "SHELF"
@export var tutorial_identifiers : Array = ["INTERACT"]

func player_interact() -> void:
	message.emit([{"recipient": "dialogue scene", "topic": "start dialogue"}, ["TEST CHARACTER NAME"]])
	message.emit([{"recipient": "tutorial scene", "topic": "start tutorial"}, ["TEST CHARACTER NAME"]])
