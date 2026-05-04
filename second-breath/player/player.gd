extends CharacterBody3D
class_name Player

signal toggle_inventory()
signal toggle_skilltree()
signal interact_hover()

const speed : int = 5
const jumpspeed : int = 20
var jump : int = 2
var cooldownOff : bool = true
var skillCooldownOff : bool = true
var direction: Vector3
var bullseye : CompressedTexture2D = preload("uid://boe62hylmoryp")
var interact_label : bool = false

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

@onready var attack : CollisionShape3D = $AttackHitbox/AttackHitboxCollision
@onready var melee_sprite: AnimatedSprite3D = $AttackHitbox/MeleeSprite

@onready var cooldown : Timer = $cooldown
@onready var skillCooldown : Timer = $skillCooldown
@onready var camera: Camera3D = $camera_controller/camera_target/Camera3D
@onready var camera_controller: Node3D = $camera_controller
@onready var camera_target: Node3D = $camera_controller/camera_target
@onready var cam_collider: RayCast3D = $CamCollider

@onready var talent_tree: TalentTree = $"../UI/talent_tree"
@onready var health_bar: ProgressBar = $"../UI/HealthBar"
@onready var attack_hitbox: Area3D = $AttackHitbox
@onready var state_machine: StateMachine = $PlayerStateMachine

@onready var interact_ray: RayCast3D = $InteractRay

var mouse_position : Vector2
var ray_origin : Vector3
var ray_direction : Vector3
var camray_direction : Vector3
var ray_length: float = 50.0
var close_enough : bool
var explosion : PackedScene = preload("res://attack_skills/explosion.tscn")
var explodes : bool = false
var healthDrain : bool = false
var sprites_between_cam : Array = []
var current_obstacle_sprite : Node
var camera_has_obstacle : bool = false

# left click, E and Q skill
@export var LSkill : int
@export var ESkill : int
@export var QSkill : int
var lastSkill : int

func _ready() -> void:
	Global.player = self
	attack.disabled = true
	melee_sprite.visible = false
		

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
		Global.aggro_enemies.clear()
		# stop all other processes when player dies
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		get_tree().reload_current_scene.call_deferred()


func _physics_process(_delta: float) -> void:
	if is_on_floor() and state_machine.return_current_state() != "jump":
		velocity.y = 0
		jump = 2
	else:
		velocity.y -= 1
	
	move_and_slide()
	
	# only check mouse position when viewport exists
	if is_inside_tree() == true and get_viewport() != null:
		mouse_position = get_viewport().get_mouse_position()
		
	#setup raycast node's origin and direction
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_direction = camera.project_ray_normal(mouse_position)
	cam_collider.target_position = camera_target.global_position - position
	
	# Move the RayCast3D to the camera's position
	interact_ray.global_position = camera_target.global_position
	# Point it in the direction of the mouse
	interact_ray.target_position = ray_direction * 50.0
	
	# if something is between camera and the player
	if cam_collider.is_colliding():
		var camera_obstacle : Node = cam_collider.get_collider()
		if camera_obstacle:
			# find the sprite 3D child of the obstacle
			for obstacle_child : Node in camera_obstacle.find_children("*"):
				if obstacle_child is AnimatedSprite3D or obstacle_child is Sprite3D:
					camera_has_obstacle = true
					current_obstacle_sprite = obstacle_child
					# turn obstacle semi-transparent
					obstacle_child.modulate.a = 0.5
					sprites_between_cam.append(obstacle_child)
					break
				else:
					camera_has_obstacle = false
		else:
			camera_has_obstacle = false
	else:
		camera_has_obstacle = false
	
	if !camera_has_obstacle:
		current_obstacle_sprite = null
	
	# turn previous obstacles opaque
	#ignore untyped declaration because other_obstacle could be freed
	@warning_ignore("untyped_declaration")
	for other_obstacle in sprites_between_cam:
		if other_obstacle != current_obstacle_sprite and is_instance_valid(other_obstacle):
			other_obstacle.modulate.a = 1
			sprites_between_cam.remove_at(0)
				
	# move camera in the direction of the player's movement
	camera_controller.position = lerp(camera_controller.position,position + Vector3(velocity.x, velocity.y * 0.7,velocity.z + 3)*0.5, 0.04)
	
	# if enemies are targeting player, change camera's position to look at objects from above
	# otherwise, return camera position to horizontal
	if Global.aggro_enemies.is_empty():
		camera_target.position = lerp(camera_target.position, Vector3(0, 1.2, 4), 0.05)
		camera_target.rotation_degrees = lerp(camera_target.rotation_degrees, Vector3(-15, 0, 0), 0.03)
	else:
		camera_target.position = lerp(camera_target.position, Vector3(0, 3.4, 5.6), 0.05)
		camera_target.rotation_degrees = lerp(camera_target.rotation_degrees, Vector3(-30, 0, 0), 0.03)
	
	if interact_ray.is_colliding():
		var collider : Node = interact_ray.get_collider()

		#print(collision_point)
		if collider is Node:
			var distance_with_collider : Vector3 = abs(position - collider.global_position) 
			if distance_with_collider.x < 3 and distance_with_collider.z < 3:
				close_enough = true
			else:
				close_enough = false
			if collider.is_in_group("enemy"):
				Input.set_custom_mouse_cursor(bullseye, Input.CURSOR_CROSS, Vector2(25,25))
			elif collider.is_in_group("external_inventory") and close_enough:
				interact_hover.emit(true)
				interact_label = true
				Input.set_custom_mouse_cursor(null)
			else:
				interact_label = false
				interact_hover.emit(false)
				Input.set_custom_mouse_cursor(null)
		else:
			Input.set_custom_mouse_cursor(null)


func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") && attack.disabled == false:
		if body.has_method("upon_hit"): 
			var id : int = body.id
			Global.enemyHitID.append(id)
			enemy_hit()
			print(Global.enemyHitID)
			if Global.skillType == 6:
				Global.health += 6
			elif Global.skillType == 9:
				Global.health += 2

	
#func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	#if body.is_in_group("enemy") && attack.disabled == false:
		#if body.has_method("upon_hit"): 
			#var id = body.id
			#Global.enemyHitID.append(id)
			#enemy_hit()


func enemy_hit() -> void:
	Global.enemyIsHit = true
	
	
func _on_cooldown_timeout() -> void:
	cooldownOff = true


func _on_skill_cooldown_timeout() -> void:
	skillCooldownOff = true


func interact() -> void:
	if interact_ray.is_colliding():
		var collider : Node = interact_ray.get_collider()
		if collider.has_method("player_interact"):
			collider.player_interact()


func get_drop_position() -> Vector3:
	return global_position + direction + Vector3(0, 1,0)


func heal(heal_value:int) -> void:
	Global.health += heal_value
	if Global.health > Global.maxHealth:
		Global.health = Global.maxHealth
	health_bar.health_changed()


func _on_attack_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemyHurtbox") && attack.disabled == false:
		if area.get_parent().has_method("upon_hit"): 
			var id : int = area.get_parent().id
			Global.enemyHitID.append(id)
			enemy_hit()


func damage_taken() -> void:
	health_bar.health_changed()
