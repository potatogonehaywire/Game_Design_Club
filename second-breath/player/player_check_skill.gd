extends State

var timeInEffect = 0

#consume more stamina for higher level skills
func check_skill() -> void:
	match parent.lastSkill:
		1: #basic anger
			Global.health -= 10
			Global.debuff = 5
			state_machine.change_state("melee")
			timeInEffect = 8
			parent.skillCooldown.wait_time = 10
		2: #basic fear
			state_machine.change_state("ranged")
			parent.skillCooldown.wait_time = 5
		3: #basic envy
			Global.dmgdebuff = 3
			state_machine.change_state("melee")
			parent.skillCooldown.wait_time = 10
			timeInEffect = 8
		4: #max level anger
			Global.debuff = 8
			Global.health -= 15
			state_machine.change_state("melee")
			parent.skillCooldown.wait_time = 15
			timeInEffect = 15
		5: #max level fear
			state_machine.change_state("ranged")
			parent.skillCooldown.wait_time = 8
		6: #max level envy
			Global.debuff = -2
			state_machine.change_state("melee")
			parent.skillCooldown.wait_time = 15
			timeInEffect = 10
		7: #anger/fear hybrid
			Global.maxHealth = 80
			Global.weapon = 2
			parent.speed = 7
			state_machine.change_state("melee")
			#change cooldown and time in effect from here onwards
		8: #fear/envy
			state_machine.change_state("ranged")
		9: #anger/envy
			Global.debuff = 5
			Global.dmgdebuff = 5
			Global.maxHealth = 120
			state_machine.change_state("melee")
			#Strong buffs(atk+hp) and debuff every enemy you hit(reduce enemy atk)
		_:
			state_machine.change_state("melee")

	
func enter() -> void:
	pass

func exit() -> void:
	await get_tree().create_timer(timeInEffect).timeout
	parent.skillCooldownOff = false

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
