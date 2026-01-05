extends CharacterBody3D

var canDamage = true
var my_id = 0
#var unique_run_id: int = 0
#var isHit = false
const speed = 15
@export var id = 0
@export var enemyhp = 30


func _ready() -> void:
	my_id = self.id
	print(name, " is id ", my_id)

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


func upon_hit():
	my_id = Global.enemyHitID
	if self.my_id == Global.enemyHitID:
		if self.enemyhp > 0:
			take_damage()
	else:
		print("sad")

func take_damage() -> void:
	if self.canDamage == true:
		Global.enemyIsHit = false
		self.canDamage = false
		if Global.isProjectile == true:
			self.enemyhp -= 10 * Global.ranged
			Global.isProjectile = false
		else:
			self.enemyhp -= 15 * Global.weapon
		if self.enemyhp <= 0:
			Global.enemyIsHit = false
			self.queue_free()
			print("eurgh")
		else:
			print (self.enemyhp)
			self.canDamage = true
	
