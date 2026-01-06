extends Control
class_name TalentTree

@onready var points_label: Label = $PointsLabel

var talent_points = 30

func _ready() -> void:
	set_points_label()
	setup_points()
	

func setup_points():
	for talent in get_children():
		if talent is TalentSlot:
			talent.set_label()


func get_points_left():
	var points_spent = 0
	for talent in get_children():
		if talent is TalentSlot:
			points_spent += talent.level
	return talent_points - points_spent


func set_points_label():
	points_label.text = str(get_points_left())
