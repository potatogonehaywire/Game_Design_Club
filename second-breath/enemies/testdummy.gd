extends CharacterBody3D

var canDamage = true
var my_id = 0
var isInRange = false
var isHit = false
@onready var projectile: PackedScene = preload("res://attack_skills/projectile.tscn")
@onready var cooldown = $ProjectileCooldown
@onready var muzzle_location: Marker3D = $projectileMarkerThing
@export var speed = 1
@export var id = 0
@export var ENEMY_HP_MAX = 30
var enemyhp = ENEMY_HP_MAX
@export var damage = 20
@export var enemyType = 1
@onready var health_bar: ProgressBar = $"../UI/HealthBar"
@onready var enemy_health_sprite: Sprite3D = $EnemyHealthSprite
@onready var state_machine: StateMachine = $StateMachine
@export var starting_location: Vector3 = Vector3.ZERO

func _ready() -> void:
	starting_location = global_position
	my_id = self.id
	print(name, " is id ", my_id)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(_delta: float) -> void:
	if isHit == true:
		await get_tree().create_timer(1).timeout
		isHit = false


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and isHit == false:
		isHit = true
		state_machine.change_state("attack")


func upon_hit():
	my_id = Global.enemyHitID
	if self.my_id == Global.enemyHitID:
		if self.enemyhp > 0:
			take_damage()
			enemy_health_sprite.enemy_health_changed()
	else:
		print("sad")


func take_damage() -> void:
	if self.canDamage == true:
		Global.enemyIsHit = false
		self.canDamage = false
		if Global.isProjectile == true:
			self.enemyhp -= 10 * Global.ranged + Global.debuff
			Global.isProjectile = false
			isHit = true
			Global.debuff = 0
			Global.dmgdebuff = 0
			Global.windup = 2
		else:
			self.enemyhp -= 15 * Global.weapon + Global.debuff
			Global.debuff = 0
			Global.dmgdebuff = 0
		if self.enemyhp <= 0:
			Global.enemyIsHit = false
			self.queue_free()
			print("eurgh")
		else:
			print (self.enemyhp)
			self.canDamage = true
	

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		isInRange = true
		cooldown.start(1)


func _on_chase_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		isInRange = false
		cooldown.stop()


func _on_projectile_cooldown_timeout() -> void:
	if isInRange == true:
		var direction_to_target = (global_position.direction_to(Global.get_global_position())).normalized()
		print(direction_to_target)
		var projectile_instance = projectile.instantiate()
		get_tree().current_scene.add_child(projectile_instance)

		projectile_instance.global_position = muzzle_location.global_position
		projectile_instance.move_direction = direction_to_target
		projectile_instance.isPlayer = false
	else:
		pass
