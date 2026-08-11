extends Node3D

@onready var opening_loop: AudioStreamPlayer = $opening_loop

func _on_opening_intro_finished() -> void:
	opening_loop.play()
