extends Sprite3D

@onready var character_name: Label = $SubViewport/CharacterName
@onready var character : CharacterBody3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_name.text = character.display_name
