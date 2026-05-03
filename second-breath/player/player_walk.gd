extends State

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta:float) -> void:
	pass

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
	
	if Input.is_action_just_pressed("skill") && parent.skillCooldownOff == true:
		parent.skillCooldownOff = false
		if Global.skillType == 0 || Global.skillType == 2:
			await get_tree().create_timer(Global.windup).timeout
			state_machine.change_state("ranged")
		else:
			state_machine.change_state("melee")
		
	if Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
		state_machine.change_state("jump")
	
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && parent.cooldownOff == true:
		state_machine.change_state("melee")
	
	if parent.velocity.x == 0 and parent.velocity.z == 0:
		state_machine.change_state("idle")

func handle_input(_delta:float) -> void:
	pass
