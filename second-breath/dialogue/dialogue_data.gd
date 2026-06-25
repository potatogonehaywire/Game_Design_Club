extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Probably keep dialogue data
func _dialogue_string(identifier):
	# If you need to change the stored dialogue data in any way, you can do that here.
	return identifier + " (dialogue string function applied to message)"
