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
		if parent.velocity.y == 0:
			if parent.velocity == Vector3.ZERO:
				state_machine.change_state("idle")
			else:
				state_machine.change_state("walk")

func physics_update(_delta:float) -> void:
	pass

func handle_input(_delta:float) -> void:
	pass
