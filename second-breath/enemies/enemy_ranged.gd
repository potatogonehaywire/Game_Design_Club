extends State
class_name EnemyRanged

var attack_time : float = 1
var player: CharacterBody3D = null
var attack_direction: Vector3
@onready var enemy: CharacterBody3D = $"../.."
@onready var projectile: PackedScene = preload("res://attack_skills/projectile.tscn")
@onready var muzzle_location: Marker3D = $"../../projectileMarkerThing"

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	var direction_to_target : Vector3 = (enemy.global_position.direction_to(Global.get_global_position())).normalized()
	var projectile_instance : CharacterBody3D = projectile.instantiate()
	get_tree().current_scene.add_child(projectile_instance)

	projectile_instance.global_position = muzzle_location.global_position
	projectile_instance.move_direction = direction_to_target
	projectile_instance.isPlayer = false
	projectile_instance.enemyType = enemy.enemyType
	projectile_instance.debuff = enemy.debuff

func exit() -> void:
	pass

func update(delta:float) -> void:
	attack_time -= delta
	if attack_time <= 0:
		state_machine.change_state("pursuit")


func physics_update(_delta:float) -> void:
	pass
