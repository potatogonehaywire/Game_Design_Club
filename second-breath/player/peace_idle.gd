extends State
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var dialogue_root: Control = $"../../../UI/DialogueRoot"

func enter() -> void:
	parent.velocity.x = 0
	parent.velocity.z = 0

func exit() -> void:
	pass

func update(_delta:float) -> void:
	animation_tree.set("parameters/StateMachine/Idle/blend_position", Vector2(parent.direction.x, parent.direction.z))
	
	# check if player is pressing WASD
	var hDirection : float = Input.get_axis("left", "right")
	var vDirection : float= Input.get_axis("forward", "backward")
	
	
	if dialogue_root.visible == false:
		if Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
			state_machine.change_state("jump")
		
		if hDirection != 0 or vDirection != 0:
			state_machine.change_state("walk")
		
		
func physics_update(_delta:float) -> void:
	pass
