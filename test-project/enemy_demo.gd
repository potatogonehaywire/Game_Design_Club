extends CharacterBody3D

@onready var timer = $Timer
var enemyhp = 300
const speed = 15
var enemyHit = false

func _process(_delta: float) -> void:
	if enemyHit == true:
		enemyhp -= 15
		if enemyhp <= 0:
			queue_free()
			await get_tree().create_timer(5.0).timeout
		

func _physics_process(_delta: float) -> void:
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= 3
	
	move_and_slide()


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.health -= 20
		print (Global.health)
	await get_tree().create_timer(2.0).timeout
