extends Node3D

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var player : Player = get_owner()

func _physics_process(_delta: float) -> void:
	animation_tree.set("parameters/walking/blend_position", Vector2(player.direction.x, player.direction.z))
