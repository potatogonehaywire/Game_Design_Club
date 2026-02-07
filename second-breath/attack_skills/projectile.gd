extends CharacterBody3D

var move_direction := Vector3.ZERO
var speed := 5.5 
var life_timer := 2.0 
var enemyType = 0
var projectileType = Global.projectileType
@onready var explosionRadius = $explosion/explosionRadius

#everything from here is for each type of projectile
var explodes = false
var dmgDebuff = false
var healthDrain = false

func _ready():
	match projectileType:
		0:
			life_timer = 2.0
		1: #basic anger
			healthDrain = true
			Global.debuff = 5
		2: #basic fear
			life_timer = 4.0
			explodes = true
		3: #basic envy
			dmgDebuff = true
		4: #basic regret
			Global.windup = 4
	print(projectileType)
	await get_tree().create_timer(life_timer).timeout
	if explodes == true:
		explosionRadius.disabled = false
	queue_free()

func _process(_delta):
	if speed > 3.0:
		speed -= 0.075
	else:
		speed -= 0
	velocity = move_direction * speed
	move_and_slide()

func _on_projectile_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("upon_hit"): 
			var id = body.id
			Global.enemyHitID = id
			Global.isProjectile = true
			enemy_hit()
			

func _on_explosion_body_entered(body: Node3D) -> void:
	enemy_hit()
	Global.debuff += 5
	
func enemy_hit() -> void:
	Global.enemyIsHit = true
	if dmgDebuff == true:
		Global.debuff = -5
	if healthDrain == true:
		Global.health -= 20
		print (Global.health)
		healthDrain == false
	if explodes == true:
		explosionRadius.disabled = false
	Global.debuff = 0
	Global.windup = 2
	queue_free()
