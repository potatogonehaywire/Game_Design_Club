extends CharacterBody3D

@onready var timer = $Timer
var enemyhp = 30
var canDamage = true
const speed = 15


func _process(_delta: float) -> void:
	if Global.enemyHit == true && canDamage == true:
		enemyhp -= 15
		canDamage = false
		timer.start(0.5)
		timer.timeout.connect(_on_timer_timeout)
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


func _on_timer_timeout() -> void:
	canDamage = true
	
