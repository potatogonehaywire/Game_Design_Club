extends State
class_name EnemyAttack


var player: CharacterBody3D = null
@onready var enemy: CharacterBody3D = $"../.."

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")


func exit() -> void:
	pass

func update(_delta:float) -> void:
	Global.health -= enemy.damage + Global.dmgdebuff
	enemy.health_bar.health_changed()
	print ("ENEMY ATTACK", Global.health)
	state_machine.change_state("pursuit")


func physics_update(_delta:float) -> void:
	pass
