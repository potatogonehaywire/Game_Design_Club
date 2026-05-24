extends Sprite3D

@onready var enemy_health_bar: ProgressBar = $SubViewport/Panel/EnemyHealthBar


func _ready() -> void:
	enemy_health_bar.max_value = get_parent().enemyMaxHp
	enemy_health_bar.value = get_parent().enemyhp
	

func enemy_health_changed() -> void:
	enemy_health_bar.value = get_parent().enemyhp
