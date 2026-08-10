extends Control
class_name QuestManager
@onready var quest_title: Label = $"../NotMenu/QuestDisplay/Background/MarginContainer/VBoxContainer/QuestTitle"
@onready var quest_desc: Label = $"../NotMenu/QuestDisplay/Background/MarginContainer/VBoxContainer/QuestDesc"
@onready var quest_display: Control = $"../NotMenu/QuestDisplay"

@export_group("Quest Settings")
@export var quest_name : String
@export var quest_description : String
@export var return_text : String

enum QuestStatus{
	available,
	started,
	reached_goal,
	finished,
}

@export var quest_status : QuestStatus = QuestStatus.available

@export_group("Reward Settings")
@export var reward_type : String
@export var reward_amount : int
