extends Node3D

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var player : Player = get_owner()
@onready var weapon_animation_tree: AnimationTree = $"../AttackHitbox/WeaponAnimationTree"


func _physics_process(_delta: float) -> void:

	animation_tree.set("parameters/StateMachine/Idle/blend_position", Vector2(player.direction.x, player.direction.z))
	animation_tree.set("parameters/StateMachine/Walk/blend_position", Vector2(player.direction.x, player.direction.z))
