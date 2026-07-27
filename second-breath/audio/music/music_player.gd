extends Node3D
@onready var base_bgm_intro: AudioStreamPlayer = $base_bgm_intro
@onready var base_bgm_loop: AudioStreamPlayer = $base_bgm_loop


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_base_bgm_intro_finished() -> void:
	base_bgm_loop.play()
