extends TextureProgressBar
class_name CooldownBar
var player : Player
@export var button_pressed : String
var skill_used : int
var skill_node : Node
var cooldown : Timer
var skill_colour : Color

func check_skill() -> void:
	match button_pressed:
		"L":
			skill_used = player.LSkill
			cooldown = player.get_node("cooldown")
		"E":
			skill_used = player.ESkill
			cooldown = player.get_node("skillCooldown")
		"R":
			skill_used = player.RSkill
			cooldown = player.get_node("skillCooldown3")
		"Q":
			skill_used = player.QSkill
			cooldown = player.get_node("skillCooldown2")


func find_colour() -> void:
	skill_node = player.skill_dict[skill_used].instantiate()
	tint_progress = skill_node.colour
	
			
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	check_skill()
	find_colour()

func _process(_delta: float) -> void:
	value = 100 - cooldown.time_left / cooldown.wait_time * 100

	
