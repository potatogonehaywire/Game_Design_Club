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
#var damaged = null
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

@onready var inventory_root: Control = $"../UI/InventoryRoot"
@onready var talent_tree: TalentTree = $"../UI/talent_tree"
@onready var health_bar: ProgressBar = $"../UI/HealthBar"
@onready var attack_hitbox: Area3D = $AttackHitbox
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var ProjectileScene: PackedScene = preload("res://attack_skills/projectile.tscn")
@onready var muzzle_location: Marker3D = $projectileMarkerThing
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
	
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && cooldownOff == true:
		Global.weapon_check()
		attack.disabled = false
		Global.stamina -= 10
		cooldownOff = false
		attack_hitbox.position = direction * 0.9
		# change hitbox's sprite rotation based on player's direction
		match direction:
			Vector3(1, 0 ,0):
				attack_hitbox.rotation = Vector3(0,0,0)
			Vector3(1, 0, 1):
				attack_hitbox.rotation = Vector3(-PI/2,0,0)
			Vector3(0, 0 ,1):
				attack_hitbox.rotation = Vector3(PI/2,0,0)
			Vector3(-1, 0, 1):
				attack_hitbox.rotation = Vector3(-PI/2,PI,0)
			Vector3(-1, 0 ,0):
				attack_hitbox.rotation = Vector3(0,PI,0)
			Vector3(1, 0, -1):
				attack_hitbox.rotation = Vector3(PI/2,0,0)
			Vector3(-1, 0, -1):
				attack_hitbox.rotation = Vector3(PI/2,PI,0)
			Vector3(0, 0, -1):
				attack_hitbox.rotation = Vector3(-PI/2,0,0)
			_:
				attack_hitbox.rotation = Vector3(0,0,0)
				
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		melee_sprite.visible = true
			
		await get_tree().create_timer(1).timeout
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		melee_sprite.visible = false
		attack.disabled = true
		cooldown.start(0.5)

	if Input.is_action_just_pressed("skill") && skillCooldownOff == true:
		skillCooldownOff = false
		if Global.skillType == 0 || Global.skillType == 2:
			await get_tree().create_timer(Global.windup).timeout
			shoot()
		else:
			check_skill()
	

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
			animation_tree.set("parameters/OneShot 2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
	else:
		velocity.y -= 1
		if Input.is_action_just_pressed("jump") && jump >= 1 && Global.stamina >= 15:
			Global.stamina -= 15
			velocity.y = 0
			velocity.y += jumpspeed
			jump -= 1
			animation_tree.set("parameters/OneShot 2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	#if Input.is_action_just_pressed("skill") && skillCooldownOff == true:
		#skillCooldownOff = false
		#if Global.skillType == 0 || Global.skillType == 2:
			#await get_tree().create_timer(Global.windup).timeout
			#shoot()
		#else:
			#check_skill()
	
	move_and_slide()
	
	# only check mouse position when viewport exists
	if is_inside_tree() == true and get_viewport() != null:
		mouse_position = get_viewport().get_mouse_position()
		
	#ray_origin = camera.project_ray_origin(Vector2.ZERO)
	
	#setup raycast node's origin and direction
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_direction = camera.project_ray_normal(mouse_position)
	cam_collider.target_position = camera_target.global_position - position
	
	# Move the RayCast3D to the camera's position
	interact_ray.global_position = Global.get_global_position()
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


func shoot() -> void:
	if talent_tree.visible == false:
		#var mouse_position = get_viewport().get_mouse_position()
		#var ray_origin = camera.project_ray_origin(mouse_position)
		#var ray_direction = camera.project_ray_normal(mouse_position)
		#var ray_length = 100.0 
		#var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction * ray_length)

		#var space_state = get_world_3d().direct_space_state
		#var result = space_state.intersect_ray(query)

		var target_point: Vector3
		var collider : Node = interact_ray.get_collider()
		var collision_point : Vector3 = interact_ray.get_collision_point()
		print(collision_point)
		#ray_origin + ray_direction * ray_length
		if collider is Node:
			if collider.is_in_group("enemy"):
				target_point = interact_ray.get_collision_normal()
			else:
				target_point = interact_ray.get_collision_point()

			var direction_to_target : Vector3 = muzzle_location.global_position.direction_to(target_point).normalized()
			print(direction_to_target)
			var projectile_instance : Node = ProjectileScene.instantiate()
			if inventory_root.visible == false:
				get_tree().current_scene.add_child(projectile_instance)
	
				projectile_instance.global_position = muzzle_location.global_position
				projectile_instance.move_direction = direction_to_target
				projectile_instance.isPlayer = true
	skillCooldown.start(1)
	#await get_tree().create_timer(Global.windup).timeout


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


#note make sure to transfer all changes to testdummy as well
func check_skill() -> void:
	match Global.skillType:
		1: #basic anger
			healthDrain = true
			Global.debuff = 5
			skillCooldown.start(1)
		3: #basic envy
			Global.dmgdebuff = 3
			skillCooldown.start(1)
		4: #max level anger
			healthDrain = true
			Global.debuff = 8
			skillCooldown.start(1)
		5: #max level fear
			explodes = true
			Global.debuff = -10.0 * Global.ranged
			skillCooldown.start(1)
		6: #max level envy
			pass
			Global.debuff = -2
			skillCooldown.start(1)
		7: #anger/fear hybrid
			Global.maxHealth = 180
			skillCooldown.start(1)
			#Global.weapon += 2, reverse after cooldown.. Global thing for speed and multiply character speed in player script by the global thing
		8: #fear/envy
			pass
			skillCooldown.start(1)
			#make bom go boom but no dmg but debuff
		9: #anger/envy
			pass
			skillCooldown.start(1)
			#Strong buffs(atk+hp) and debuff every enemy you hit(reduce enemy atk)
		_:
			Global.skillType = 0
	use_skill()


func use_skill() -> void:
	if healthDrain == true:
		if Global.skillType == 1:
			Global.health -= 10
		if Global.skillType == 4:
			Global.health -= 20
			print (Global.health)
			healthDrain = false
	Global.enemyIsHit = true
	if explodes == true:
		explode()


func explode() -> void:
	var explosion_instance : Node = explosion.instantiate()
	add_child(explosion_instance)
	explosion_instance.global_position = self.global_position
	Global.debuff = 0
	await get_tree().create_timer(1).timeout
	explosion_instance.queue_free()


func damage_taken() -> void:
	health_bar.health_changed()
