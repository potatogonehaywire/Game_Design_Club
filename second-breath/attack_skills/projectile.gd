extends CharacterBody3D

var move_direction := Vector3.ZERO
var speed := 15.0
var life_timer := 2.0 
var enemyType = 0
var isPlayer = false
var projectileType = Global.skillType
var explosion = preload("res://attack_skills/explosion.tscn")
@onready var projectile_sprite: AnimatedSprite3D = $ProjectileSprite


#everything from here is for each type of projectile
var explodes = false
var healthDrain = false
var debuff = 0

#Global.debuff not working, to fix. all basic attack work.
func _ready():
	if isPlayer == false:
		projectileType = enemyType
	match projectileType:
		0:
			life_timer = 2.0

			projectile_sprite.set_modulate("ff4b64")
		1: #basic anger
			healthDrain = true
			Global.debuff = 3
			if isPlayer == true:
				Global.debuff = 5
			projectile_sprite.set_modulate("ff4b64")

		2: #basic fear
			life_timer = 2.0
			speed = 10
			explodes = true
			if isPlayer == true:
				life_timer = 3.0
				speed = 13


			projectile_sprite.set_modulate("9337ff")
		3: #basic envy
			Global.dmgdebuff = 2
			if isPlayer == true:
				Global.dmgdebuff = 3
			projectile_sprite.set_modulate("00d6b4")
		4: #max level anger
			healthDrain = true
			Global.debuff = 5 #make specific enemy one (separate each projectile to also have their own type within script)
			if isPlayer == true:
				Global.debuff = 8
		5: #max level fear
			pass
			#knockback **
		6: #max level envy
			pass
			Global.debuff = -4
			if isPlayer == true:
				Global.debuff = -2
		7: #anger/fear hybrid
			Global.maxHealth = 80
			#Global.weapon += 2, reverse after cooldown.. Global thing for speed and multiply character speed in player script by the global thing
		8: #fear/envy
			pass
			#make bom go boom but no dmg but debuff
		9: #anger/envy
			pass
			#Strong buffs(atk+hp) and debuff every enemy you hit(reduce enemy atk)
		_:
			pass
	print(projectileType)
	await get_tree().create_timer(life_timer).timeout
	if explodes == true:
		explode()
	else:
		queue_free()

func _physics_process(_delta):
	velocity = move_direction * speed
	move_and_slide()

func _on_projectile_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") && isPlayer == true:
		if body.has_method("upon_hit"): 
			var id = body.id
			Global.enemyHitID.append(id)
			Global.isProjectile = true
			print(Global.enemyHitID)
	elif body.is_in_group("player") && isPlayer == false:
		#not hitting player, fix later (and also give health to enemies)
		#also do the same sorta code thing in explosion.gd once it works
		Global.health -= 10 + debuff
		print(Global.health)
		#if Global.projectileType == 6:
			#Global.health += 6
		#elif Global.projectileType == 9:
			#Global.health += 2
		#enemy_hit()
			
	elif body.is_in_group("player") && isPlayer == false:
		#not hitting player, fix later (and also give health to enemies)
		#also do the same sorta code thing in explosion.gd once it works
		Global.health -= 10 + Global.debuff
		body.damage_taken()

func enemy_hit() -> void:
	if healthDrain == true:
		if Global.projectileType == 1:
			Global.health -= 10
		if Global.projectileType == 4:
			Global.health -= 20
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
	Global.debuff = 0
	await get_tree().create_timer(1).timeout
	explosion_instance.queue_free()
	queue_free()
