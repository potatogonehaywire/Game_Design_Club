extends State

var timeInEffect : int = 0
var skillCooldown : int
var skillCooldown2 : int
var skillUsed : Node

#consume more stamina for higher level skills
#not alloweed to use 2 skills at once
func check_skill() -> void:
	match parent.lastSkill:
		1: #basic anger
			skillUsed = parent.anger1.instantiate()
			parent.skill_effect.mesh.material.emission = Color("ff417c")
			parent.skill_effect.emitting = true
			state_machine.change_state("melee")
		2: #basic fear
			skillUsed = parent.fear1.instantiate()
			state_machine.change_state("ranged")
		3: #basic envy
			skillUsed = parent.envy1.instantiate()
			state_machine.change_state("melee")
		4: #max level anger
			skillUsed = parent.angerMax.instantiate()
			parent.skill_effect.mesh.material.emission = Color("ba0043")
			parent.skill_effect.emitting = true
			state_machine.change_state("melee")
		5: #max level fear
			skillUsed = parent.fearMax.instantiate()
			state_machine.change_state("ranged")
		6: #max level envy
			Global.debuff = -2
			skillUsed = parent.envyMax.instantiate()
			state_machine.change_state("melee")
		7: #anger/fear hybrid
			skillUsed = parent.anger_fear.instantiate()
			Global.weapon = 2
			parent.speed = 7
			parent.skill_effect.mesh.material.emission = Color("980097ff")
			parent.skill_effect.emitting = true
			state_machine.change_state("melee")
		8: #fear/envy
			skillUsed = parent.fear_envy.instantiate()
			state_machine.change_state("ranged")
		9: #anger/envy
			skillUsed = parent.anger_envy.instantiate()
			Global.weapon = 1.5
			parent.skill_effect.mesh.material.emission = Color("93924bff")
			parent.skill_effect.emitting = true
			state_machine.change_state("melee")
		10: #basic heal
			skillUsed = parent.heal1.instantiate()
			state_machine.change_state("idle")
		_:
			state_machine.change_state("melee")
			
	get_tree().current_scene.add_child(skillUsed)
	
	
func enter() -> void:
	print(parent)
	skillUsed = parent.base.instantiate()

func exit() -> void:
	parent.skillCooldown.wait_time = skillUsed.skillCooldown
	parent.skillCooldown2.wait_time = skillUsed.skillCooldown
	
	timeInEffect = skillUsed.timeInEffect
	if Global.health > skillUsed.healthChange:
		Global.health += skillUsed.healthChange
	Global.debuff = skillUsed.debuff
	Global.dmgdebuff = skillUsed.dmgDebuff
	Global.maxHealth = skillUsed.maxHealth
	parent.health_bar.max_value = Global.maxHealth
	parent.health_bar.health_changed()
	
	if parent.isESkill == true:
		parent.skillCooldownOff = false
		parent.isESkill = false
		await get_tree().create_timer(timeInEffect).timeout
		parent.speed = 5
		parent.skillCooldown.start()
		print("E cooldown started")
		print(parent.skillCooldown.wait_time)
	elif parent.isQSkill == true:
		parent.skillCooldownOff2 = false
		parent.isQSkill = false
		await get_tree().create_timer(timeInEffect).timeout
		parent.speed = 5
		parent.skillCooldown2.start()
		print("Q cooldown started")

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
