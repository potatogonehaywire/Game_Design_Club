extends CharacterBody3D

var move_direction : Vector3 = Vector3.ZERO
var speed : float = 15.0
var life_timer : float = 2.0 
var isPlayer : bool = false
var projectileType : int = 0
var explosion : PackedScene = preload("res://attack_skills/explosion.tscn")
@onready var projectile_sprite: AnimatedSprite3D = $ProjectileSprite


#everything from here is for each type of projectile
var explodes : bool = false
var healthDrain : bool = false
var debuff : float = 0

#Global.debuff not working, to fix. all basic attack work.
func _ready() -> void:
	match projectileType:
		0:
			projectile_sprite.set_modulate("ff4b64")
			life_timer = 2.0

		2: #basic fear
			projectile_sprite.set_modulate("9337ff")
			life_timer = 2.0
			speed = 10
			explodes = true
			if isPlayer == true:
				life_timer = 3.0
				speed = 13
		8: # fear & envy
			projectile_sprite.set_modulate("5600eb")
			explodes = true
		_:
			pass
	print(projectileType)
	await get_tree().create_timer(life_timer).timeout
	if explodes == true:
		explode()
	else:
		queue_free()


func _physics_process(_delta : float) -> void:
	velocity = move_direction * speed
	move_and_slide()


func _on_projectile_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") && isPlayer == true:
		if body.has_method("upon_hit"): 
			var id : int = body.id
			Global.enemyIsHit = true
			Global.enemyHitID.append(id)
			Global.isProjectile = true
			print(Global.enemyHitID)
			if explodes:
				explode()
				explodes = false
	elif body.is_in_group("player") && isPlayer == false:
		#not hitting player, fix later (and also give health to enemies)
		#also do the same sorta code thing in explosion.gd once it works
		Global.health -= 10 + debuff
		print("player hp: ", Global.health)
		if projectileType == 6:
			Global.health += 6
		elif projectileType == 9:
			Global.health += 2
		body.damage_taken()
		#enemy_hit()
		if explodes:
				explode()
				explodes = false

func explode() -> void:
	var explosion_instance : Area3D = explosion.instantiate()
	explosion_instance.get_explosion_type(projectileType)
	add_child(explosion_instance)
	explosion_instance.global_position = self.global_position
	speed = 0
	Global.debuff = 0
	await get_tree().create_timer(1).timeout
	explosion_instance.queue_free()
	queue_free()

func get_projectile_type(entity_type : int) -> void:
	projectileType = entity_type
