extends Node

signal changed_skill(button : String, skill : String)
@onready var l_skill: MenuButton = $ColorRect/ChangeSkill/VBoxContainer/LSkill
@onready var q_skill: MenuButton = $ColorRect/ChangeSkill/VBoxContainer/QSkill
@onready var e_skill: MenuButton = $ColorRect/ChangeSkill/VBoxContainer/ESkill
@onready var r_skill: MenuButton = $ColorRect/ChangeSkill/VBoxContainer/RSkill
@onready var skill_container: VBoxContainer = $ColorRect/ChangeSkill/VBoxContainer

var font : FontFile = preload("uid://blkksf3ub3qsr")
var picked_skill : String

func update_list() -> void:
	for child in skill_container.get_children():
		child.queue_free()
		
	for skill : String in Global.available_skills:
		l_skill.get_popup().add_item(skill)
		q_skill.get_popup().add_item(skill)
		e_skill.get_popup().add_item(skill)
		r_skill.get_popup().add_item(skill)
	l_skill.get_popup().set("font_size", 32)
	l_skill.get_popup().set("font", font)
	l_skill.get_popup().id_pressed.connect(select_skill)
	q_skill.get_popup().id_pressed.connect(select_skill)
	e_skill.get_popup().id_pressed.connect(select_skill)
	r_skill.get_popup().id_pressed.connect(select_skill)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_list()
	

func select_skill(id : int) -> void:
	changed_skill.emit(picked_skill,Global.available_skills[id])


func _on_l_skill_about_to_popup() -> void:
	picked_skill = "L"


func _on_q_skill_about_to_popup() -> void:
	picked_skill = "Q"


func _on_e_skill_about_to_popup() -> void:
	picked_skill = "E"


func _on_r_skill_about_to_popup() -> void:
	picked_skill = "R"
