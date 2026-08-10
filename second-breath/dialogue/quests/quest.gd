class_name Quest extends QuestManager

func start_quest() -> void:
	if quest_status == QuestStatus.available:
		quest_status = QuestStatus.started
		quest_display.visible = true
		quest_title.text = quest_name
		quest_desc.text = quest_description


func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		quest_status = QuestStatus.reached_goal
		quest_desc.text = return_text


func finish_quest(type : String) -> void:
	if quest_status == QuestStatus.reached_goal:
		quest_status = QuestStatus.finished
		quest_display.visible = false
		reward_type = type
		if type in ["anger", "envy", "fear"]:
			Global.collected_fragments[type] += reward_type
