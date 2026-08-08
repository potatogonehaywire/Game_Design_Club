extends Node

@onready var player: CharacterBody3D = $Player
@onready var talent_tree: TalentTree = $UI/TalentRoot/talent_tree
@onready var ui: CanvasLayer = $UI
@onready var talent_root: Control = $UI/TalentRoot
@onready var not_menu: Control = $UI/NotMenu
@onready var dialogue_root : Control = $UI/DialogueRoot
@onready var dialogue_box : Control = $UI/DialogueRoot/DialogueBox
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
	dialogue_box.finished_dialogue.connect(dialogue_ended)

func toggle_skilltree_interface() -> void:
	if skill_root.visible:
		toggle_player_stats()
	if !dialogue_root.visible:
		skill_manager.update_list()
		talent_root.visible = not talent_root.visible
		not_menu.visible = not talent_root.visible

func toggle_dialogue_box(visible : bool) -> void:
	if talent_root.visible:
		toggle_skilltree_interface()
	if skill_root.visible:
		toggle_player_stats()
	dialogue_root.visible = visible
	not_menu.visible = not visible

func toggle_player_stats() -> void:
	if talent_root.visible:
		toggle_skilltree_interface()
	if !dialogue_root.visible:
		skill_root.visible = not skill_root.visible
		not_menu.visible = not skill_root.visible


func show_interact_hover(visible : bool) -> void:
	if visible:
		ui.find_child("InteractLabel").show()
	else:
		ui.find_child("InteractLabel").hide()


func change_skill(button : int, skill : String) -> void:
	match button:
		1:
			player.LSkill = skill
			l_cooldown.change_skill()
		2:
			player.ESkill = skill
			e_cooldown.change_skill()
		3:
			player.RSkill = skill
			r_cooldown.change_skill()
		4:
			player.QSkill = skill
			q_cooldown.change_skill()


func dialogue_ended() -> void:
	toggle_dialogue_box(false)
