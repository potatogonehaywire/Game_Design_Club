extends State
class_name EnemyAttack

var wait_time = 0.1
var attack_time = 1
var player: CharacterBody3D = null
var attack_direction: Vector3
@onready var enemy: CharacterBody3D = $"../.."
@onready var hitbox: Area3D = $"../../Hitbox"

func reset_time() -> void:
	attack_time = 1
	wait_time = randf_range(0.1, 1)

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	randomize()


func attacking() -> void:
	attack_direction = enemy.position.direction_to(Global.player.position)
	hitbox.position = attack_direction * Vector3(5,2,5)

func exit() -> void:
	hitbox.position = Vector3(0,0,0)

func update(delta:float) -> void:
	wait_time -= delta
	if wait_time <= 0:
		attacking()
		attack_time -= delta
		if attack_time <= 0:
			hitbox.position = Vector3(0,0,0)
			reset_time()
	if enemy.meleeInRange == false and attack_time == 1:
		state_machine.change_state("pursuit")


func physics_update(_delta:float) -> void:
	pass
