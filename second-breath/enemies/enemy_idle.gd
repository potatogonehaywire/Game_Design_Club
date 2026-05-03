extends State
class_name EnemyIdle
var wait_time: float 

func enter() -> void:
	randomize()
	wait_time = randf_range(5, 15)
	

func exit() -> void:
	pass

func update(delta:float) -> void:
	wait_time -= delta
	if wait_time < 0:
		state_machine.change_state("wander")
	if parent.isInRange == true:
		state_machine.change_state("pursuit")


func physics_update(_delta:float) -> void:
	if not parent.is_on_floor():
		parent.velocity.y = -3
	else:
		parent.velocity.y = 0
