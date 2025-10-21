extends CharacterBody3D

const speed = 5
const jumpspeed = 20
var jump = 2

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	elif Input.is_action_pressed("right"):
		velocity.x = speed
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("forward"):
		velocity.z = -speed
	elif Input.is_action_pressed("backward"):
		velocity.z = speed
	else:
		velocity.z = 0
		
	if is_on_floor():
		velocity.y = 0
		jump = 2
		if Input.is_action_just_pressed("jump") && jump >= 1:
			velocity.y += jumpspeed
			jump -= 1
	else:
		velocity.y -= 2
		if Input.is_action_just_pressed("jump") && jump >= 1:
			velocity.y = 0
			velocity.y += jumpspeed
			jump -= 1
	move_and_slide()
