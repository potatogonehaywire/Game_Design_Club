class_name StateMachine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary[String, State] = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
			#child.Transitioned.connect(change_state)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
	#print(current_state)
	
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	print(current_state, new_state)
	assert(new_state, "State not found: " + new_state_name)
	
	if current_state: 
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state 
