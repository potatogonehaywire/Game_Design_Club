extends State
class_name EnemyPursuit
var player: CharacterBody3D = null
var skill1 : Node
var skill2 : Node

func enter() -> void:
	skill1 = parent.basic_skill.instantiate()
	skill2 = parent.max_skill.instantiate()
	
	player = get_tree().get_first_node_in_group("player")
	if parent.my_id not in Global.aggro_enemies:
		Global.aggro_enemies.append(parent.my_id)
		
	if parent.lastSkill == 0 && parent.basicCooldownOff:
		parent.basic_cooldown.wait_time = randf_range(skill1.skillCooldown, skill1.skillCooldown * 2)
		if parent.max_cooldown.time_left < 1:
			parent.max_cooldown.wait_time = randf_range(2, 5)
			parent.max_cooldown.start()
			parent.maxCooldownOff = false
		parent.basicCooldownOff = false
		parent.basic_cooldown.start()
	elif parent.lastSkill == 1 && parent.maxCooldownOff:
		parent.max_cooldown.wait_time = randf_range(skill2.skillCooldown * 1.5, skill2.skillCooldown * 2)
		parent.max_cooldown.start()
		if parent.basic_cooldown.time_left < 1:
			parent.basic_cooldown.wait_time = randf_range(1.5, 3)
			parent.basic_cooldown.start()
			parent.basicCooldownOff = false
		parent.maxCooldownOff = false
	elif parent.basicCooldownOff && parent.maxCooldownOff:
		parent.basic_cooldown.wait_time = randf_range(skill1.skillCooldown * 0.5, skill1.skillCooldown)
		parent.max_cooldown.wait_time = randf_range(skill2.skillCooldown, skill2.skillCooldown * 2)
		parent.basic_cooldown.start()
		parent.max_cooldown.start()
		parent.basicCooldownOff = false
		parent.maxCooldownOff = false

func exit() -> void:
	pass


func update(_delta:float) -> void:
	pass


func physics_update(_delta:float) -> void:
	if parent.is_on_floor():
		parent.velocity.y = 0
	else:
		parent.velocity.y -= 3
	
	parent.velocity = parent.position.direction_to(Global.player.position) * parent.speed * 2
	
	if parent.meleeInRange:
		state_machine.change_state("attack")
		
	
	if parent.isInRange != true and Global.aggro_enemies.size() > 0:
		Global.aggro_enemies.erase(parent.my_id)
		state_machine.change_state("return")

	
