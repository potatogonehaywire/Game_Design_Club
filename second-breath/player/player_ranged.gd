extends State
@onready var ui_root: Control = $"../../../UI/UIRoot"
@onready var interact_ray: RayCast3D = $"../../InteractRay"
@onready var muzzle_location: Marker3D = $"../../projectileMarkerThing"
const ProjectileScene : PackedScene = preload("uid://cypk7ydkr5r7b")

func enter() -> void:
	parent.skillCooldownOff = false
	if ui_root.visible == false:
		var target_point: Vector3
		var collider : Node = interact_ray.get_collider()
		if collider is Node:
			if collider.is_in_group("enemy"):
				target_point = interact_ray.get_collision_normal()
			else:
				target_point = interact_ray.get_collision_point()

			var direction_to_target : Vector3 = muzzle_location.global_position.direction_to(target_point).normalized()
			print(direction_to_target)
			var projectile_instance : Node = ProjectileScene.instantiate()
			if ui_root.visible == false:
				projectile_instance.get_projectile_type(parent.lastSkill)
				get_tree().current_scene.add_child(projectile_instance)
				projectile_instance.global_position = muzzle_location.global_position
				projectile_instance.move_direction = direction_to_target
				projectile_instance.isPlayer = true
	parent.skillCooldown.start(1)

func exit() -> void:
	pass

func update(_delta:float) -> void:
	# check if player used WASD
	var hDirection : float = Input.get_axis("left", "right")
	var vDirection : float= Input.get_axis("forward", "backward")

	if Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
		state_machine.change_state("jump")
		
	if hDirection == 0 and vDirection == 0:
		state_machine.change_state("idle")
	else:
		state_machine.change_state("walk")

func physics_update(_delta:float) -> void:
	pass
