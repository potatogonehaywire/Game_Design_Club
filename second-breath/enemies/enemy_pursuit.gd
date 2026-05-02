extends State
class_name EnemyPursuit
var player: CharacterBody3D = null
@onready var enemy: CharacterBody3D = $"../.."

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if enemy.my_id not in Global.aggro_enemies:
		Global.aggro_enemies.append(enemy.my_id)


func exit() -> void:
	pass


func update(_delta:float) -> void:
	pass


func physics_update(_delta:float) -> void:
	if enemy.is_on_floor():
		enemy.velocity.y = 0
	else:
		enemy.velocity.y -= 3
	
	enemy.velocity = enemy.position.direction_to(Global.player.position) * enemy.speed * 2
	
	if enemy.meleeInRange:
		state_machine.change_state("attack")
		
	
	if enemy.isInRange != true and Global.aggro_enemies.size() > 0:
		Global.aggro_enemies.erase(enemy.my_id)
		state_machine.change_state("return")

	
