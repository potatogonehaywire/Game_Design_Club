extends Node3D

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var player : Player = get_owner()

func _physics_process(_delta: float) -> void:
	var idle = !player.velocity
	animation_tree.set("parameters/StateMachine/conditions/run", !idle)
	animation_tree.set("parameters/StateMachine/conditions/idle", idle)
	if player.velocity == Vector3(0,0,0):
		animation_tree.set("parameters/idle/blend_position", Vector2(player.direction.x, player.direction.z))
	else:
		animation_tree.set("parameters/walking/blend_position", Vector2(player.direction.x, player.direction.z))
