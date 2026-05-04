extends State
@onready var animation_tree: AnimationTree = $"../../AnimationTree"

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta:float) -> void:
	animation_tree.set("parameters/StateMachine/Walk/blend_position", Vector2(parent.direction.x, parent.direction.z))

	if Input.is_action_just_pressed("skill2") && Global.stamina > 10 && parent.cooldownOff == true:
		parent.lastSkill = parent.QSkill
		state_machine.change_state("checkskill")
		
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && parent.cooldownOff == true:
		parent.lastSkill = parent.LSkill
		state_machine.change_state("checkskill")
		
	if Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
		state_machine.change_state("jump")
	
	if Input.is_action_just_pressed("skill") && parent.skillCooldownOff == true:
		parent.lastSkill = parent.ESkill
		state_machine.change_state("checkskill")
		
	if parent.velocity.x == 0 and parent.velocity.z == 0:
		state_machine.change_state("idle")
		
		
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
