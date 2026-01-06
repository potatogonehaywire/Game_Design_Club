extends TextureButton
class_name TalentSlot

const DEFAULT_LINE_COLOUR = Color(0.47, 0.47, 0.47, 1.0)

@export var talent_id: String
@export var tier: int = 1
@export var max_level: int = 1
@export var depends_on: Array[TalentSlot]

@onready var label: Label = $MarginContainer/Label
@onready var disabled_panel: Panel = $DisabledPanel
@onready var talent_line: TalentLine = $TalentLine

var level = 0


func _ready() -> void:
	for talent in depends_on:
		var line:TalentLine = talent_line.duplicate()
		line.dependent_talent_id = talent.talent_id
		line.set_point_position(0, global_position + size/2)
		line.add_point(talent.global_position + talent.size/2)
		line.visible = true
		add_child(line)
		

func set_label():
	label.text = str(level) + "/" + str(max_level)
	disabled_panel.visible = level == 0
	for talent in get_parent().get_children():
		if talent is TalentSlot:
			for line in talent.get_children():
				if line is TalentLine and line.dependent_talent_id == talent_id:
					line.default_color = Color.WHITE if level > 0 else DEFAULT_LINE_COLOUR


func can_be_increased():
	var result = get_parent().get_points_left() > 0
	for talent in depends_on:
		if talent.level == 0:
			result = false
	return result


func can_be_decreased():
	var has_active_children = false
	for talent in get_parent().get_children():
		if talent is TalentSlot and talent.depends_on.has(self) and talent.level > 0:
			has_active_children = true
	return level > 1 or not has_active_children


func set_new_level(next_level:int):
	level = clamp(next_level, 0, max_level)
	set_label()
	get_parent().set_points_label()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: 
		var next_level = level
		if event.button_index == MOUSE_BUTTON_LEFT and can_be_increased():
			next_level += 1
		elif event.button_index == MOUSE_BUTTON_RIGHT and can_be_decreased():
			next_level -= 1
		set_new_level(next_level)
