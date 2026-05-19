extends State

var timeInEffect : int = 0
var skillCooldown : int
var skillCooldown2 : int
var skillUsed : Node
var ranged : bool = false

#consume more stamina for higher level skills
#not alloweed to use 2 skills at once ?
func check_skill() -> void:
	match parent.lastSkill:
		1: #basic anger
			skillUsed = parent.s1.instantiate()
			state_machine.change_state("melee")
		2: #basic fear
			skillUsed = parent.s2.instantiate()
			state_machine.change_state("ranged")
		3: #basic envy
			skillUsed = parent.s3.instantiate()
			state_machine.change_state("melee")
		4: #max level anger
			skillUsed = parent.s4.instantiate()
			state_machine.change_state("melee")
		5: #max level fear
			skillUsed = parent.s5.instantiate()
			state_machine.change_state("ranged")
		6: #max level envy
			skillUsed = parent.s6.instantiate()
			state_machine.change_state("melee")
		7: #anger/fear hybrid
			skillUsed = parent.s7.instantiate()
			Global.weapon = 2
			parent.speed = 7
			state_machine.change_state("melee")
		8: #fear/envy
			skillUsed = parent.s8.instantiate()
			state_machine.change_state("ranged")
		9: #anger/envy
			skillUsed = parent.s9.instantiate()
			Global.weapon = 1.5
			state_machine.change_state("melee")
		_:
			state_machine.change_state("melee")
			
	get_tree().current_scene.add_child(skillUsed)
	
	
func enter() -> void:
	pass

func exit() -> void:
	if skillUsed.staminaDrain < Global.stamina:
		parent.skillCooldown.wait_time = skillUsed.skillCooldown
		parent.skillCooldown2.wait_time = skillUsed.skillCooldown
		
		parent.store_stats()
		
		timeInEffect = skillUsed.timeInEffect
		Global.health -= skillUsed.healthDrain
		Global.stamina -= skillUsed.staminaDrain
		Global.debuff = skillUsed.debuff
		Global.dmgdebuff = skillUsed.dmgDebuff
		Global.maxHealth = skillUsed.maxHealth
		parent.health_bar.max_value = Global.maxHealth
		parent.health_bar.health_changed()
		
		if parent.isESkill == true:
			parent.skillCooldownOff = false
			parent.canUseESkill = true
			await get_tree().create_timer(timeInEffect).timeout
			parent.speed = 5
			Global.weapon = 1
			parent.skillCooldown.start()
			print("E cooldown started")
		elif parent.isQSkill == true:
			parent.skillCooldownOff2 = false
			parent.canUseQSkill = true
			await get_tree().create_timer(timeInEffect).timeout
			parent.speed = 5
			parent.skillCooldown2.start()
			print("Q cooldown started")
	else:
		if parent.isESkill == true:
			parent.skillCooldownOff = true
			parent.isESkill = false
			parent.canUseESkill = false
		elif parent.isQSkill == true:
			parent.skillCooldownOff2 = true
			parent.isQSkill = false
			parent.canUseQSkill = false

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
