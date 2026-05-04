extends State
@onready var attack: CollisionShape3D = $"../../AttackHitbox/AttackHitboxCollision"
@onready var attack_hitbox: Area3D = $"../../AttackHitbox"
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var melee_sprite: AnimatedSprite3D = $"../../AttackHitbox/MeleeSprite"


func enter() -> void:
	# player stops moving when attacking, player would slide around otherwise
	parent.velocity.x = 0
	parent.velocity.z = 0
	Global.weapon_check()
	attack.disabled = false
	Global.stamina -= 10
	parent.cooldownOff = false
	attack_hitbox.position = parent.direction * 0.9
	# change hitbox's sprite rotation based on player's direction
	match parent.direction:
		Vector3(1, 0 ,0): #right
			attack_hitbox.rotation = Vector3(0,0,0)
		Vector3(1, 0, 1): #backwardright
			attack_hitbox.rotation = Vector3(-PI/2,0,0)
		Vector3(0, 0 ,1): #backwards
			attack_hitbox.rotation = Vector3(PI/2,0,0)
		Vector3(-1, 0, 1): #backwardleft
			attack_hitbox.rotation = Vector3(-PI/2,PI,0)
		Vector3(-1, 0 ,0): #left
			attack_hitbox.rotation = Vector3(0,PI,0)
		Vector3(1, 0, -1): #forwardright
			attack_hitbox.rotation = Vector3(PI/2,0,0)
		Vector3(-1, 0, -1): #forwardleft
			attack_hitbox.rotation = Vector3(PI/2,PI,0)
		Vector3(0, 0, -1): #forward
			attack_hitbox.rotation = Vector3(-PI/2,0,0)
		_:
			attack_hitbox.rotation = Vector3(0,0,0)
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	melee_sprite.visible = true
	await get_tree().create_timer(1).timeout
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	melee_sprite.visible = false
	attack.disabled = true
	
func exit() -> void:
	parent.cooldown.start(0.5)

func update(_delta:float) -> void:
	# check if player uses WASD
	var hDirection : float = Input.get_axis("left", "right")
	var vDirection : float= Input.get_axis("forward", "backward")
	
	if attack.disabled:
		if hDirection == 0 and vDirection == 0:
			state_machine.change_state("idle")
		else:
			state_machine.change_state("walk")

func physics_update(_delta:float) -> void:
	pass
