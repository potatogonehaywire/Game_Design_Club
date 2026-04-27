extends State
class_name EnemyReturn

var player: CharacterBody3D = null
@onready var enemy: CharacterBody3D = $"../.."

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")

func exit() -> void:
	pass

func update(_delta:float) -> void:
	if enemy.isInRange == true:
		state_machine.change_state("pursuit")

func physics_update(_delta:float) -> void:
	if enemy.is_on_floor():
		enemy.velocity.y = 0
	else:
		enemy.velocity.y -= 3
	
	#if enemy.isInRange == true:
		#enemy.velocity = Vector3.ZERO
	enemy.velocity = enemy.global_position.direction_to(enemy.starting_location) * enemy.speed
	if enemy.global_position.distance_squared_to(enemy.starting_location) < 5:
		state_machine.change_state("idle")
	#else:
		#velocity.x = 0
		#velocity.z = 0
	
