extends State

var timeInEffect = 0

#consume more stamina for higher level skills
func check_skill() -> void:
	match parent.lastSkill:
		1: #basic anger
			Global.health -= 10
			Global.debuff = 5
			timeInEffect = 8
			parent.skillCooldown.wait_time = 10
			parent.skillCooldown2.wait_time = 10
			state_machine.change_state("melee")
		2: #basic fear
			timeInEffect = 0
			parent.skillCooldown.wait_time = 5
			parent.skillCooldown2.wait_time = 5
			state_machine.change_state("ranged")
		3: #basic envy
			Global.dmgdebuff = 3
			parent.skillCooldown.wait_time = 10
			parent.skillCooldown2.wait_time = 10
			timeInEffect = 8
			state_machine.change_state("melee")
		4: #max level anger
			Global.debuff = 8
			Global.health -= 15
			parent.skillCooldown.wait_time = 15
			parent.skillCooldown2.wait_time = 15
			timeInEffect = 15
			state_machine.change_state("melee")
		5: #max level fear
			timeInEffect = 0
			parent.skillCooldown.wait_time = 8
			parent.skillCooldown2.wait_time = 8
			state_machine.change_state("ranged")
		6: #max level envy
			Global.debuff = -2
			parent.skillCooldown.wait_time = 15
			parent.skillCooldown2.wait_time = 15
			timeInEffect = 10
			state_machine.change_state("melee")
		7: #anger/fear hybrid
			Global.maxHealth = 80
			Global.weapon = 2
			parent.speed = 7
			parent.skillCooldown.wait_time = 20
			parent.skillCooldown2.wait_time = 20
			timeInEffect = 15
			state_machine.change_state("melee")
		8: #fear/envy
			timeInEffect = 0
			parent.skillCooldown.wait_time = 10
			parent.skillCooldown2.wait_time = 10
			state_machine.change_state("ranged")
		9: #anger/envy
			Global.debuff = 5
			Global.dmgdebuff = 5
			Global.maxHealth = 120
			Global.weapon = 1.5
			parent.skillCooldown.wait_time = 25
			parent.skillCooldown2.wait_time = 25
			timeInEffect = 15
			state_machine.change_state("melee")
		_:
			state_machine.change_state("melee")

	
func enter() -> void:
	pass

func exit() -> void:
	parent.health_bar.max_value = Global.maxHealth
	parent.health_bar.health_changed()
	if parent.isESkill == true:
		parent.skillCooldownOff = false
		parent.isESkill = false
		await get_tree().create_timer(timeInEffect).timeout
		parent.speed = 5
		print("cooldown started")
		parent.skillCooldown.start()
	elif parent.isQSkill == true:
		parent.skillCooldownOff2 = false
		parent.isQSkill = false
		await get_tree().create_timer(timeInEffect).timeout
		parent.speed = 5
		print("cooldown started")
		parent.skillCooldown2.start()

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
