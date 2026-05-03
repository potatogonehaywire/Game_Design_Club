extends CharacterBody3D

var canDamage : bool = true
var my_id : int = 0
var isInRange : bool = false
var meleeInRange : bool = false
var isHit : bool = false


@onready var cooldown: Timer = $ProjectileCooldown

@export var speed : float = 1
@export var id : int = 0
@export var ENEMY_HP_MAX : float = 50.0
var enemyhp : float = ENEMY_HP_MAX
@export var damage : int = 20
@export var enemyType : int = 1

@onready var health_bar: ProgressBar = $"../UI/HealthBar"
@onready var enemy_health_sprite: Sprite3D = $EnemyHealthSprite
@onready var state_machine: StateMachine = $StateMachine
@export var starting_location: Vector3 = Vector3.ZERO
@onready var enemy_animation_tree: AnimationTree = $EnemyAnimationTree


#var explosion = preload("res://attack_skills/explosion.tscn")
var explodes : bool = false
var healthDrain : bool = false
#var skillType = Global.skillType
var debuff : int = 0
var dmgdebuff : int = 0
var windup : int = 2

func _ready() -> void:
	starting_location = global_position
	my_id = self.id
	print(name, " is id ", my_id)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(_delta: float) -> void:
	enemy_animation_tree.set("parameters/Idle/blend_position", Vector2(velocity.x,velocity.z))
	if isHit == true:
		await get_tree().create_timer(0.5).timeout
		isHit = false
	if speed < 1:
		speed += 0.2


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and isHit == false:
		isHit = true
		Global.health -= damage + Global.dmgdebuff
		health_bar.health_changed()


func upon_hit() -> void:
	#my_id = Global.enemyHitID
	#if self.my_id == Global.enemyHitID:
	#Global.enemyHitID.clear()
	#Global.enemyHitID.append(my_id)
	#if self.my_id in Global.enemyHitID:
	if self.enemyhp > 0.0:
		take_damage()
		enemy_health_sprite.enemy_health_changed()


func take_damage() -> void:
		Global.enemyIsHit = false
		self.canDamage = false
		if Global.isProjectile == true:
			if Global.skillType == 5:
					self.speed *= -1
			elif Global.skillType == 8:
				pass
			else:
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
			if my_id in Global.aggro_enemies:
				Global.aggro_enemies.erase(my_id)
			self.queue_free()
			print("eurgh")
		else:
			print (self.enemyhp)
			self.canDamage = true


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		isInRange = true
		cooldown.start(2)


func _on_chase_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		isInRange = false
		cooldown.stop()


func _on_projectile_cooldown_timeout() -> void:
	if isInRange == true:
		state_machine.change_state("ranged")


#func check_skill() -> void:
	#match self.skillType:
		#1: #basic anger
			#healthDrain = true
			#debuff = 3
		#3: #basic envy
			#dmgdebuff = 2
		#4: #max level anger
			#healthDrain = true
			#debuff = 5 
		#5: #max level fear
			#explodes = true
			#debuff = -10 
		#6: #max level envy
			#pass
			#debuff = -4
		#_:
			#skillType = 0
	
			
#func explode() -> void:
	#var explosion_instance = explosion.instantiate()
	#add_child(explosion_instance)
	#explosion_instance.global_position = self.global_position
	#explosion_instance.isEnemy = true
	#Global.debuff = 0
	#await get_tree().create_timer(1).timeout
	#explosion_instance.queue_free()


func _on_hurtbox_body_shape_entered(_body_rid: RID, _body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	pass
	#if body.is_in_group("playerHitbox"):
		#take_damage()


func _on_melee_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		meleeInRange = true


func _on_melee_detection_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		meleeInRange = false
