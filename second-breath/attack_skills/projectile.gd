extends CharacterBody3D

var move_direction := Vector3.ZERO
var speed := 5.5 
var life_timer := 2.0 

func _ready():
	await get_tree().create_timer(life_timer).timeout
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
			

func enemy_hit() -> void:
	Global.enemyIsHit = true
	queue_free()
