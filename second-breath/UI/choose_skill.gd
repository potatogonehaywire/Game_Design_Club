extends Node

signal changed_skill(button : int, skill : String)
@onready var change_skill: VBoxContainer = $ColorRect/ChangeSkill
@onready var hp: Label = $ColorRect/Stats/VBoxContainer/HP
@onready var stamina: Label = $ColorRect/Stats/VBoxContainer/STAMINA
@onready var speed: Label = $ColorRect/Stats/VBoxContainer/Speed
@onready var atk: Label = $ColorRect/Stats/VBoxContainer/ATK


var font : FontFile = preload("uid://blkksf3ub3qsr")
var picked_skill : int = 0

func update_list() -> void:
	for container : HBoxContainer in change_skill.get_children():
		picked_skill += 1
		for child : Node in container.get_children():
			if child is OptionButton:
				container.remove_child(child)
				child.queue_free()
			
		var button : OptionButton = OptionButton.new()
		container.add_child(button)
		for skill : String in Global.available_skills:
			button.add_item(skill)
		
		button.item_selected.connect(update_skill.bind(picked_skill))
	
	picked_skill = 0
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_list()
	
func update_skill(id : int, button : int) -> void:
	changed_skill.emit(button, Global.available_skills[id])


func _process(_delta: float) -> void:
	hp.text = "HP: " + str(Global.health) + "/" + str(Global.maxHealth)
