extends CharacterBody3D
class_name Player

signal toggle_inventory()
signal toggle_skilltree()

const speed = 5
const jumpspeed = 20
var jump = 2
var cooldownOff = true
var rangedCooldownOff = true
var damaged = null
var direction: Vector3

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

@onready var attack = $AttackHitbox/AttackHitboxCollision
@onready var cooldown = $cooldown
@onready var rangedCooldown = $rangedCooldown
@onready var camera: Camera3D = $camera_controller/camera_target/Camera3D
@onready var camera_controller: Node3D = $camera_controller
@onready var inventory_root: Control = $"../UI/InventoryRoot"
@onready var talent_tree: TalentTree = $"../UI/talent_tree"
@onready var health_bar: ProgressBar = $"../UI/HealthBar"
@onready var attack_hitbox: Area3D = $AttackHitbox
@onready var animation_tree: AnimationTree = $AnimationTree


var ProjectileScene: PackedScene = preload("res://attack_skills/projectile.tscn")
@onready var muzzle_location: Marker3D = $projectileMarkerThing

func _ready() -> void:
	Global.player = self
	attack.disabled = true
	Global.player = self
	

func _unhandled_input(_event: InputEvent) -> void:
 
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("interact"):
		interact()
	
	if Input.is_action_just_pressed("skill_tree"):
		toggle_skilltree.emit()


func _process(_delta: float) -> void:
	if Global.health <= 0:
		Global.health = 100
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && cooldownOff == true:
		Global.weapon_check()
		attack.disabled = false
		Global.stamina -= 10
		cooldownOff = false
		attack_hitbox.position = direction * 0.6
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		await get_tree().create_timer(0.4).timeout
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		attack.disabled = true
		cooldown.start(0.5)
	if Input.is_action_just_pressed("ranged") && rangedCooldownOff == true:
		rangedCooldownOff = false
		rangedCooldown.start(1)
		shoot()
		

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		direction.x = -1
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		direction.x = 1
	else:
		velocity.x = 0
		if velocity.z != 0:
			direction.x = 0
		
	if Input.is_action_pressed("forward"):
		velocity.z = -speed
		direction.z = -1

	elif Input.is_action_pressed("backward"):
		velocity.z = speed
		direction.z = 1

	else:
		velocity.z = 0
		if velocity.x != 0:
			direction.z = 0
		
	if is_on_floor():
		velocity.y = 0
		jump = 2
		if Input.is_action_just_pressed("jump") && jump >= 1 && Global.stamina >= 15:
			Global.stamina -= 15
			velocity.y += jumpspeed
			jump -= 1
	else:
		velocity.y -= 2
		if Input.is_action_just_pressed("jump") && jump >= 1 && Global.stamina >= 15:
			Global.stamina -= 15
			velocity.y = 0
			velocity.y += jumpspeed
			jump -= 1
	move_and_slide()

	camera_controller.position = lerp(camera_controller.position,position + Vector3(velocity.x, 0,velocity.z + 3)*0.5, 0.04)

func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") && attack.disabled == false:
		if body.has_method("upon_hit"): 
			var id = body.id
			Global.enemyHitID.append(id)
			enemy_hit()

func enemy_hit() -> void:
	Global.enemyIsHit = true

func _on_cooldown_timeout() -> void:
	cooldownOff = true

func _on_ranged_cooldown_timeout() -> void:
	rangedCooldownOff = true

func shoot():
	await get_tree().create_timer(Global.windup).timeout
	if talent_tree.visible == false:
		var mouse_position = get_viewport().get_mouse_position()
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_direction = camera.project_ray_normal(mouse_position)
		var ray_length = 500.0 
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * ray_length)

		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)

		var target_point: Vector3
		if result:
			target_point = result.position
		else:
			target_point = ray_origin + ray_direction * ray_length

		var direction_to_target = (target_point - muzzle_location.global_position).normalized()

		var projectile_instance = ProjectileScene.instantiate()
		if inventory_root.visible == false:
			get_tree().current_scene.add_child(projectile_instance)

			projectile_instance.global_position = muzzle_location.global_position
			projectile_instance.move_direction = direction_to_target
			projectile_instance.isPlayer = true
		else:
			pass


func interact() -> void:
		var mouse_position = get_viewport().get_mouse_position()
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_direction = camera.project_ray_normal(mouse_position)
		var ray_length = 50
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * ray_length)

		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)

		if result:
			var collider = result.collider
			if collider.has_method("player_interact"):
				collider.player_interact()



func get_drop_position() -> Vector3:
	return global_position + direction


func heal(heal_value:int) -> void:
	Global.health += heal_value
	health_bar.health_changed()
	print("player health: " + str(Global.health))
