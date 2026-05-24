extends ProgressBar

func _ready() -> void:
	value = Global.health
	max_value = Global.maxHealth
	
func health_changed() -> void:
	value = Global.health
	max_value = Global.maxHealth
