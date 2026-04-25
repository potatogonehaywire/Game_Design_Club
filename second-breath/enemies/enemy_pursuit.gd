extends State
class_name EnemyPursuit
signal enemies_calm()
var player: CharacterBody3D = null
@onready var enemy: CharacterBody3D = $"../.."

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if enemy.my_id not in Global.aggro_enemies:
		Global.aggro_enemies.append(enemy.my_id)
	print(Global.aggro_enemies)

func exit() -> void:
	print(Global.aggro_enemies)

func update(_delta:float) -> void:
	pass

func physics_update(_delta:float) -> void:
	if enemy.is_on_floor():
		enemy.velocity.y = 0
	else:
		enemy.velocity.y -= 3
	
	#if enemy.isInRange == true:
		#enemy.velocity = Vector3.ZERO
	enemy.velocity = enemy.position.direction_to(Global.player.position) * enemy.speed
	if enemy.isInRange != true:
		Global.aggro_enemies.remove_at(0)
		if Global.aggro_enemies.is_empty():
			print("EMPTY")
			enemies_calm.emit()
		else:
			print(Global.aggro_enemies.is_empty())
		state_machine.change_state("return")
	#else:
		#velocity.x = 0
		#velocity.z = 0
	
	
