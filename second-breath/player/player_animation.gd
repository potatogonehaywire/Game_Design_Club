extends Node3D

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var player : Player = get_owner()
@onready var weapon_animation_tree: AnimationTree = $"../AttackHitbox/WeaponAnimationTree"


var stopped : bool = true

func _physics_process(_delta: float) -> void:
	if player.velocity == Vector3.ZERO:
		stopped = true
	else:
		stopped = false
	
	animation_tree.set("parameters/StateMachine/conditions/melee", !player.attack.disabled)
	animation_tree.set("parameters/StateMachine/conditions/walking", !stopped)
	animation_tree.set("parameters/StateMachine/conditions/idle", stopped)
	animation_tree.set("parameters/StateMachine/Idle/blend_position", Vector2(player.direction.x, player.direction.z))
	animation_tree.set("parameters/StateMachine/Walk/blend_position", Vector2(player.direction.x, player.direction.z))
