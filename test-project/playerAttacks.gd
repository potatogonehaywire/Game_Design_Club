extends CharacterBody3D

const speed = 5
const jumpspeed = 20
var jump = 2
var cooldownOff = true
var damaged = null
@onready var attack = $AttackHitbox/AttackHitboxCollision
@onready var cooldown = $cooldown

func _ready() -> void:
	attack.disabled = true

func _process(_delta: float) -> void:
	if Global.health <= 0:
		Global.health = 100
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && cooldownOff == true:
		Global.weapon_check()
		attack.disabled = false
		Global.stamina -= 10
		await get_tree().create_timer(0.1).timeout
		attack.disabled = true
		cooldownOff = false
		cooldown.start(0.5)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = -speed
	elif Input.is_action_pressed("right"):
		velocity.x = speed
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("forward"):
		velocity.z = -speed
	elif Input.is_action_pressed("backward"):
		velocity.z = speed
	else:
		velocity.z = 0
		
	if is_on_floor():
		velocity.y = 0
		jump = 2
		if Input.is_action_just_pressed("jump") && jump >= 1 && Global.stamina >= 15:
			Global.stamina -= 15
			velocity.y += jumpspeed
			jump -= 1
	else:
		velocity.y -= 3
		if Input.is_action_just_pressed("jump") && jump >= 1 && Global.stamina >= 15:
			Global.stamina -= 15
			velocity.y = 0
			velocity.y += jumpspeed
			jump -= 1
	move_and_slide()

func _on_attack_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") && attack.disabled == false:
		if body.has_method("upon_hit"): 
			var id = body.id
			Global.enemyHitID = id
			enemy_hit()

func enemy_hit() -> void:
	Global.enemyIsHit = true

func _on_cooldown_timeout() -> void:
	cooldownOff = true
