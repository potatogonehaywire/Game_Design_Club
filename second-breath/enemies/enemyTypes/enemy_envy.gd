extends CharacterBody3D
class_name EnvyEnemy

var canDamage : bool = true
var my_id : int = 0
var isInRange : bool = false
var meleeInRange : bool = false
var isHit : bool = false

@onready var cooldown: Timer = $ProjectileCooldown


@export var speed : float = 1
@export var id : int = 0
@export var enemyMaxHp : float = 50.0
var enemyhp : float = enemyMaxHp
@export var BASE_DAMAGE : int = 20
var damage : int = BASE_DAMAGE
@export var enemyType : int = 0

@onready var health_bar: ProgressBar = $"../UI/NotMenu/HealthBar"
@onready var enemy_health_sprite: Sprite3D = $EnemyHealthSprite
@onready var state_machine: StateMachine = $StateMachine
@export var starting_location: Vector3 = Vector3.ZERO
@onready var enemy_animation_tree: AnimationTree = $EnemyAnimationTree
@onready var hurtbox: Area3D = $Hurtbox

var basic_skill : PackedScene =  preload("res://attack_skills/skill_scenes/basic_envy.tscn")
var max_skill : PackedScene =  preload("res://attack_skills/skill_scenes/max_envy.tscn")
var skillUsed : Node
var lastSkill : int = 2
@onready var skill_effect: GPUParticles3D = $SkillEffect

@onready var basic_cooldown: Timer = $BasicCooldown
@onready var max_cooldown: Timer = $MaxCooldown
var basicCooldownOff : bool = true
var maxCooldownOff : bool = true

var explodes : bool = false
var healthDrain : bool = false
var debuff : int = 0
var dmgdebuff : int = 0
#var windup : int = 2
var gotdmgDebuff : int = 0

func _ready() -> void:
	starting_location = global_position
	my_id = self.id
	#hurtbox.disabled = true
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
	if gotdmgDebuff != 0:
		await get_tree().create_timer(10).timeout
		gotdmgDebuff = 0
	
	if position.y <= -25:
		enemyhp = 0
		take_damage()


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and isHit == false:
		isHit = true
		Global.health -= damage + gotdmgDebuff
		health_bar.health_changed()


func upon_hit() -> void:
	if self.enemyhp > 0.0:
		take_damage()
		enemy_health_sprite.enemy_health_changed()


func take_damage() -> void:
	Global.enemyIsHit = false
	self.canDamage = false
	gotdmgDebuff = Global.dmgdebuff
	if Global.isProjectile == true:
		if Global.skillType == 5:
			self.speed = -16
			self.enemyhp -= Global.Pdmg * Global.ranged + Global.debuff
		elif Global.skillType == 8:
			self.speed = -16
			self.enemyhp -= Global.Pdmg * Global.ranged + Global.debuff
		else:
			self.enemyhp -= Global.Pdmg * Global.ranged + Global.debuff
			isHit = true
			Global.isProjectile = false
	else:
		self.enemyhp -= Global.dmg * Global.weapon + Global.debuff
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
	health_bar.health_changed()


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		isInRange = true
		cooldown.start(2)


func _on_chase_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		isInRange = false
		cooldown.stop()


#func _on_projectile_cooldown_timeout() -> void:
	#if isInRange == true:
		#state_machine.change_state("ranged")
	
			
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


func _on_basic_cooldown_timeout() -> void:
	basicCooldownOff = true
	print("enemy basic skill cooldown ended")
	skillUsed = basic_skill.instantiate()
	get_tree().current_scene.add_child(skillUsed)
	lastSkill = 0
	if isInRange:
		if skillUsed.type == "buff":
			state_machine.change_state("buff")
		elif skillUsed.type == "ranged":
			state_machine.change_state("ranged")
		elif skillUsed.type == "melee":
			state_machine.change_state("attack")
	

func _on_max_cooldown_timeout() -> void:
	maxCooldownOff = true
	print("enemy max skill cooldown ended")
	skillUsed = basic_skill.instantiate()
	get_tree().current_scene.add_child(skillUsed)
	lastSkill = 1
	if isInRange:
		if skillUsed.type == "buff":
			state_machine.change_state("buff")
		elif skillUsed.type == "ranged":
			state_machine.change_state("ranged")
		elif skillUsed.type == "melee":
			state_machine.change_state("attack")
