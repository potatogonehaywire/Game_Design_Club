extends State

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta:float) -> void:
	var hDirection : float = Input.get_axis("left", "right")
	var vDirection : float= Input.get_axis("forward", "backward")
	if hDirection != 0 or vDirection != 0:
		state_machine.change_state("walk")
	elif Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
		state_machine.change_state("jump")

func physics_update(_delta:float) -> void:
	pass

func handle_input(_delta:float) -> void:
	pass
