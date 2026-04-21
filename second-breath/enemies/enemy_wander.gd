extends State
class_name EnemyWander

var wander_direction: Vector3
var wander_time: float = 0.0 
var wait_time

@onready var enemy: CharacterBody3D = $"../.."

func randomize_variables() -> void:
	wander_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	wander_time = randf_range(1.5, 4)


func enter() -> void:
	randomize_variables()
	randomize()
	wait_time = randf_range(5, 20)


func exit() -> void:
	pass
	

func update(delta:float) -> void:
	if wander_time < 0.0:
		randomize_variables()
	
	wander_time -= delta
	wait_time -= delta
	
	if enemy.isInRange == true:
		state_machine.change_state("pursuit")
	
	if wait_time <= 0:
		state_machine.change_state("idle")
		
		
func physics_update(_delta:float) -> void:
	enemy.velocity = wander_direction * enemy.speed

	if not enemy.is_on_floor():
		enemy.velocity.y = -3
