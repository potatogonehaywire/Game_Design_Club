extends CharacterBody3D

var move_direction := Vector3.ZERO
var speed := 5.5 
var life_timer := 2.0 
var enemyType = 0
var isPlayer = false
var projectileType = Global.projectileType
var explosion = preload("res://attack_skills/explosion.tscn")

#everything from here is for each type of projectile
var explodes = false
var healthDrain = false

#Global.debuff not working, to fix. all basic attack work.
func _ready():
	if isPlayer == true:
		print("hi")
	else:
		print("bye")
	match projectileType:
		0:
			life_timer = 2.0
		1: #basic anger
			healthDrain = true
			Global.debuff = 5
		2: #basic fear
			life_timer = 3.0
			speed = 6.5
			explodes = true
		3: #basic envy
			Global.dmgdebuff = 3
		4: #basic regret
			Global.windup = 4
			speed = 8
			Global.debuff = 2
		_:
			Global.projectileType = 0
	print(projectileType)
	await get_tree().create_timer(life_timer).timeout
	if explodes == true:
		explode()
	else:
		queue_free()

func _physics_process(_delta):
	if projectileType == 4:
		if speed > 0:
			speed -= 0.15
		elif speed <= 0:
			speed = 0
			await get_tree().create_timer(0.1).timeout
			queue_free()
	else:
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
			Global.enemyHitID.append(id)
			Global.isProjectile = true
			print(Global.enemyHitID)
			enemy_hit()
			

func enemy_hit() -> void:
	if healthDrain == true:
		Global.health -= 10
		print (Global.health)
		healthDrain = false
	Global.enemyIsHit = true
	if explodes == true:
		explode()
	else:
		queue_free()

func explode() -> void:
	var explosion_instance = explosion.instantiate()
	add_child(explosion_instance)
	explosion_instance.global_position = self.global_position
	speed = 0
	Global.debuff -= 5
	await get_tree().create_timer(1).timeout
	explosion_instance.queue_free()
	queue_free()
