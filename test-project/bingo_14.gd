extends CharacterBody2D

var direction: Vector2 = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta_) -> void:
	if position.x > 800:
		direction = Vector2.LEFT
	if position.x < 200:
		direction = Vector2.RIGHT

	velocity = direction * 300
	move_and_slide()
