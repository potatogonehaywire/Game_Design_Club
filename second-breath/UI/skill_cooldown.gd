extends TextureProgressBar
class_name CooldownBar
var player : Player
@export var button_pressed : String
var skill_used : int
var cooldown : Timer
var cooldown_node : Timer

func check_skill() -> Timer:
	match button_pressed:
		"L":
			skill_used = player.LSkill
			cooldown_node = player.get_node("cooldown")
		"E":
			skill_used = player.ESkill
			cooldown_node = player.get_node("skillCooldown")
		"R":
			skill_used = player.RSkill
			cooldown_node = player.get_node("skillCooldown3")
		"Q":
			skill_used = player.QSkill
			cooldown_node = player.get_node("skillCooldown2")
	return cooldown_node

func find_colour() -> void:
	match skill_used:
		0 :
			tint_progress = "73829a"
		1 :
			tint_progress = "ff417c"
		2 : 
			tint_progress = "cf01f9"
		3 :
			tint_progress = "00b972"
		4 : 
			tint_progress = "ba0043"
		5 :
			tint_progress = "8601e4"
		6 :
			tint_progress = "007a52"
		7 : 
			tint_progress = "980097ff"
		8 : 
			tint_progress = "2c60a4"
		9 : 
			tint_progress = "93924bff"
		10 : 
			tint_progress = "ba0043"
			
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	cooldown = check_skill()
	find_colour()

func _process(_delta: float) -> void:
	value = 100 - cooldown.time_left / cooldown.wait_time * 100

	
