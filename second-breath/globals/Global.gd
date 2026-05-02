extends Node
var maxHealth : float = 200
var health : float = maxHealth
var stamina : int = 100

var s : int = 1
var weapon : float = 1.0
var equippedWeapon : int = 1
var ranged : float = 1.0
var equippedRanged : int = 1


var enemyHitID : Array = []
var enemyIsHit: bool = false
var isProjectile: bool = false
var debuff : float = 0
var dmgdebuff : int = 0
var windup : int = 2
var skillType : int = 0

var player : Player
var aggro_enemies : Array = []

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
	
	if health > maxHealth:
		health = maxHealth
	
	if enemyIsHit == true || enemyHitID.size() > 0:
		for node : Node in get_tree().get_nodes_in_group("enemy"):
			var f: int = node.get("id")
			if f in enemyHitID:
				if node.has_method("upon_hit"):
					node.take_damage()
					#enemyHitID.erase(node.get("id"))
				enemyHitID.erase(f)
	
	if Input.is_action_just_pressed("projectileTypeTest"):
		skillType += 1
		if skillType > 6:
			skillType = 0
		print(skillType)


func staminaRecover() -> void:
	if s == 1:
		s = 0
		stamina += 1
		await get_tree().create_timer(0.1).timeout
		s = 1
		

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
