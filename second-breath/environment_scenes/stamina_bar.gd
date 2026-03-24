extends ProgressBar


func _ready() -> void:
	value = Global.stamina

func _process(_delta: float) -> void:
	value = Global.stamina
