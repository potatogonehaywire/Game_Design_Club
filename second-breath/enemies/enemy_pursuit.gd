extends State
class_name EnemyPursuit
var player: CharacterBody3D = null

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	if parent.my_id not in Global.aggro_enemies:
		Global.aggro_enemies.append(parent.my_id)


func exit() -> void:
	pass


func update(_delta:float) -> void:
	pass


func physics_update(_delta:float) -> void:
	if parent.is_on_floor():
		parent.velocity.y = 0
	else:
		parent.velocity.y -= 3
	
	parent.velocity = parent.position.direction_to(Global.player.position) * parent.speed * 2
	
	if parent.meleeInRange:
		state_machine.change_state("attack")
		
	
	if parent.isInRange != true and Global.aggro_enemies.size() > 0:
		Global.aggro_enemies.erase(parent.my_id)
		state_machine.change_state("return")

	
