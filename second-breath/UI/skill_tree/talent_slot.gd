extends TextureButton
class_name TalentSlot

const DEFAULT_LINE_COLOUR : Color = Color(0.47, 0.47, 0.47, 1.0)

@export var talent_id: String
@export var tier: int = 1
@export var max_level: int = 1
@export var depends_on: Array[TalentSlot]

@onready var label: Label = $MarginContainer/Label
@onready var disabled_panel: Panel = $DisabledPanel
@onready var talent_line: TalentLine = $TalentLine

var skill_talents : Array = ["Basic", "Anger I", "Anger VI", "Fear I", "Fear VI", "Envy I", "Envy VI", 
							"Anger & Fear", "Fear & Envy", "Envy & Anger"]

var talents : Dictionary = {
	"_": ["Basic"], 
	"anger": ["Anger I", "Anger VI", "anger2a", "anger2b", "anger3a", "anger3b"],
	"fear" : ["Fear I", "Fear VI", "fear2a", "fear2b", "fear3a", "fear3b"],
	"envy" : ["Envy I", "Envy VI", "envy2a", "envy2b", "envy3a", "envy3b"],
	"boss" : ["Heal I", "Heal II", "Heal III"]
	}
	
var type : String = ""

var level: int = 0


func _ready() -> void:
	for talent : TalentSlot in depends_on:
		var line:TalentLine = talent_line.duplicate()
		line.dependent_talent_id = talent.talent_id
		line.set_point_position(0, global_position + size/2)
		line.add_point(talent.global_position + talent.size/2)
		line.visible = true
		add_child(line)
	
	for emotion_type : String in talents.keys():
		for skill : String in talents[emotion_type]:
			if skill == talent_id:
				type = emotion_type

func set_label() -> void:
	label.text = str(level) + "/" + str(max_level)
	disabled_panel.visible = level == 0
	for talent : Node in get_parent().get_children():
		if talent is TalentSlot:
			for line : Node in talent.get_children():
				if line is TalentLine and line.dependent_talent_id == talent_id:
					line.default_color = Color.WHITE if level > 0 else DEFAULT_LINE_COLOUR


func can_be_increased() -> bool:
	var result : bool = get_parent().get_points_left(type) > 0
	for talent : TalentSlot in depends_on:
		if talent.level == 0 or level == max_level:
			result = false
	return result


func can_be_decreased() -> bool:
	var has_active_children : bool = false
	for talent : TalentSlot in get_parent().get_children():
		if talent is TalentSlot and talent.depends_on.has(self) and talent.level > 0:
			has_active_children = true
	return level > 1 or not has_active_children


func set_new_level(next_level:int) -> void:
	level = clamp(next_level, 0, max_level)
	set_label()
	if type != "_":
		get_parent().set_points_label(type)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: 
		var next_level : int = level
		if event.button_index == MOUSE_BUTTON_LEFT and can_be_increased():
			next_level += 1
			if talent_id not in Global.available_skills && talent_id in skill_talents:
				Global.available_skills.append(talent_id)
		elif event.button_index == MOUSE_BUTTON_RIGHT and can_be_decreased():
			next_level -= 1
		set_new_level(next_level)
