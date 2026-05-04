extends State
class_name EnemyReturn

var player: CharacterBody3D = null

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")

func exit() -> void:
	pass

func update(_delta:float) -> void:
	if parent.isInRange == true:
		state_machine.change_state("pursuit")

func physics_update(_delta:float) -> void:
	if parent.is_on_floor():
		parent.velocity.y = 0
	else:
		parent.velocity.y -= 3
	
	#if parent.isInRange == true:
		#parent.velocity = Vector3.ZERO
	parent.velocity = parent.global_position.direction_to(parent.starting_location) * parent.speed
	if parent.global_position.distance_squared_to(parent.starting_location) < 5:
		state_machine.change_state("idle")
	#else:
		#velocity.x = 0
		#velocity.z = 0
	
