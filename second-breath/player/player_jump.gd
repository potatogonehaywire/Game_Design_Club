extends State
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
var delayTime : float = 0.2

func enter() -> void:
	jump()

func exit() -> void:
	pass
	
func jump() -> void:
	Global.stamina -= 15
	parent.velocity.y = parent.jumpspeed
	parent.jump -= 1
	animation_tree.set("parameters/OneShot 2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func update(delta:float) -> void:
	delayTime -= delta
	if delayTime <= 0:
		if parent.is_on_floor():
			if parent.velocity == Vector3.ZERO:
				state_machine.change_state("idle")
			else:
				state_machine.change_state("walk")
	
	if Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
		jump()
	
	if Input.is_action_just_pressed("skill2") && Global.stamina > 10 && parent.skillCooldownOff2 == true:
		parent.lastSkill = parent.QSkill
		parent.isQSkill = true
		state_machine.change_state("checkskill")
		
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && parent.cooldownOff == true:
		parent.lastSkill = parent.LSkill
		state_machine.change_state("checkskill")
		
	if Input.is_action_just_pressed("skill") && Global.stamina > 10 && parent.skillCooldownOff == true:
		parent.lastSkill = parent.ESkill
		parent.isESkill = true
		state_machine.change_state("checkskill")


func physics_update(_delta:float) -> void:
	if Input.is_action_pressed("left"):
		parent.velocity.x = -parent.speed
		parent.direction.x = -1
	elif Input.is_action_pressed("right"):
		parent.velocity.x = parent.speed
		parent.direction.x = 1
	else:
		parent.velocity.x = 0
		if parent.velocity.z != 0:
			parent.direction.x = 0
		
	if Input.is_action_pressed("forward"):
		parent.velocity.z = -parent.speed
		parent.direction.z = -1

	elif Input.is_action_pressed("backward"):
		parent.velocity.z = parent.speed
		parent.direction.z = 1

	else:
		parent.velocity.z = 0
		if parent.velocity.x != 0:
			parent.direction.z = 0
