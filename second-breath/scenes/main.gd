extends Node

@onready var player: CharacterBody3D = $Player
@onready var talent_tree: TalentTree = $UI/UIRoot/talent_tree
@onready var ui: CanvasLayer = $UI
@onready var talent_root: Control = $UI/TalentRoot
@onready var not_menu: Control = $UI/NotMenu


func _ready() -> void:
	player.toggle_skilltree.connect(toggle_skilltree_interface)
	player.interact_hover.connect(show_interact_hover)


func toggle_skilltree_interface() -> void:
	talent_root.visible = not talent_root.visible
	not_menu.visible = not not_menu.visible


func show_interact_hover(visible : bool) -> void:
	if visible:
		ui.find_child("InteractLabel").show()
	else:
		ui.find_child("InteractLabel").hide()
