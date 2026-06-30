extends CharacterBody3D

signal message

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const ENEMY_HP_MAX = 200
const enemyhp = 200

var dialogue_identifier = "GHOST 1"
var tutorial_identifiers = ["INTERACT"]

var my_id = null
var isInRange = null
var speed = 0


func physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func player_interact():
	message.emit([{"recipient": "dialogue scene", "topic": "start dialogue"}, ["TEST CHARACTER NAME"]])
	message.emit([{"recipient": "tutorial scene", "topic": "start tutorial"}, ["TEST CHARACTER NAME"]])
