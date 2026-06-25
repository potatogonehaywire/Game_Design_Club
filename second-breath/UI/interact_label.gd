extends Label

func _process(_delta: float) -> void:
	position = get_global_mouse_position() + Vector2(10,10)
