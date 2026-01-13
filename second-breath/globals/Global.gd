extends Node
var health = 100
var stamina = 100
var player = null

var i = 1
var weapon = 1
var equippedWeapon = 1
var ranged = 1
var equippedRanged = 1


var enemyHitID = 0
var enemyIsHit: bool = false
var isProjectile = false

var player

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector3:
	return player.global_position


func _process(_delta: float) -> void:
	if stamina < 100 && stamina > 0:
		staminaRecover()
	elif stamina <= 0:
		await get_tree().create_timer(2.0).timeout
		staminaRecover()
	else:
		stamina = 100
	
	if enemyIsHit == true:
		for node in get_tree().get_nodes_in_group("enemy"):
			if node.get("id") == enemyHitID:
				if node.has_method("upon_hit"):
					node.upon_hit()
					return


func staminaRecover() -> void:
	if i == 1:
		i = 0
		stamina += 1
		await get_tree().create_timer(0.1).timeout
		i = 1


func weapon_check() -> void:
	if equippedWeapon == 1:
		weapon = 1
	elif equippedWeapon == 2:
		weapon = 1.5

func ranged_weapon_check() -> void:
	if equippedRanged == 1:
		ranged = 1
	elif equippedRanged == 2:
		ranged = 1.5
