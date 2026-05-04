extends ProgressBar

func _ready() -> void:
	value = Global.health
	
func health_changed() -> void:
	value = Global.health
