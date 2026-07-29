extends Node

@onready var player: CharacterBody3D = $Player
@onready var talent_tree: TalentTree = $UI/TalentRoot/talent_tree
@onready var ui: CanvasLayer = $UI
@onready var talent_root: Control = $UI/TalentRoot
@onready var not_menu: Control = $UI/NotMenu
@onready var dialogue_root : Control = $UI/DialogueRoot
@onready var skill_root : Control = $UI/SkillRoot
@onready var skill_manager : Control = $UI/SkillRoot/SkillManager
@onready var l_cooldown : Control = $UI/NotMenu/Cooldown/LeftClickSkill
@onready var e_cooldown : Control = $UI/NotMenu/Cooldown/ESkill
@onready var q_cooldown : Control = $UI/NotMenu/Cooldown/QSkill
@onready var r_cooldown : Control = $UI/NotMenu/Cooldown/RSkill

func _ready() -> void:
	player.toggle_skilltree.connect(toggle_skilltree_interface)
	player.interact_hover.connect(show_interact_hover)
	player.toggle_dialogue.connect(toggle_dialogue_box)
	player.toggle_stats.connect(toggle_player_stats)
	skill_manager.changed_skill.connect(change_skill)

func toggle_skilltree_interface() -> void:
	skill_root.visible = false
	if !dialogue_root.visible:
		skill_manager.update_list()
		talent_root.visible = not talent_root.visible
		not_menu.visible = not not_menu.visible

func toggle_dialogue_box(visible : bool) -> void:
	talent_root.visible = false
	skill_root.visible = false
	dialogue_root.visible = visible
	not_menu.visible = not visible

func toggle_player_stats() -> void:
	talent_root.visible = false
	if !dialogue_root.visible:
		skill_root.visible = not skill_root.visible
		not_menu.visible = not not_menu.visible


func show_interact_hover(visible : bool) -> void:
	if visible:
		ui.find_child("InteractLabel").show()
	else:
		ui.find_child("InteractLabel").hide()


func change_skill(button : String, skill : String) -> void:
	match button:
		"L":
			player.LSkill = skill
			l_cooldown.change_skill()
		"E":
			player.ESkill = skill
			e_cooldown.change_skill()
		"R":
			player.RSkill = skill
			r_cooldown.change_skill()
		"Q":
			player.QSkill = skill
			q_cooldown.change_skill()
