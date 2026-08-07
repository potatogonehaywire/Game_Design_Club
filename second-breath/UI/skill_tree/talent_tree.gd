extends Control
class_name TalentTree

@onready var envy_label: Label = $EnvyLabel
@onready var anger_label: Label = $AngerLabel
@onready var fear_label: Label = $FearLabel
@onready var boss_label: Label = $BossLabel


func _ready() -> void:
	set_points_label("_")
	set_points_label("anger")
	set_points_label("fear")
	set_points_label("envy")
	set_points_label("boss")
	setup_points()


func setup_points() -> void:
	for talent : Node in get_children():
		if talent is TalentSlot:
			talent.set_label()


func get_points_left(type : String) -> int:
	var points_spent : int = 0
	for talent : Node in get_children():
		if talent is TalentSlot:
			points_spent += talent.level
	var remaining_points : int = Global.collected_fragments[type] - points_spent
	if remaining_points >= 0:
		Global.collected_fragments[type] = remaining_points
	
	return Global.collected_fragments[type]


func set_points_label(type : String) -> void:
	match type:
		"anger":
			anger_label.text = str(get_points_left(type))
		"fear":
			fear_label.text = str(get_points_left(type))
		"envy":
			envy_label.text = str(get_points_left(type))
		"boss":
			boss_label.text = str(get_points_left(type))
