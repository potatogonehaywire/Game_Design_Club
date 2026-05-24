extends State

var timeInEffect : float = 0
var skillCooldown : int
var skillCooldown2 : int
var skillUsed : Node
var ranged : bool = false

#consume more stamina for higher level skills
#not alloweed to use 2 skills at once ?
func check_skill() -> void:
	skillUsed = parent.skill_dict[parent.lastSkill].instantiate()
	parent.skillUsed = skillUsed
	if skillUsed.staminaDrain < Global.stamina:
		match skillUsed.type:
			"melee":
				state_machine.change_state("melee")
			"buff":
				state_machine.change_state("buff")
			"ranged":
				state_machine.change_state("ranged")
	else:
		state_machine.change_state("idle")
			
	get_tree().current_scene.add_child(skillUsed)
	
	
func enter() -> void:
	skillUsed = parent.base.instantiate()

func exit() -> void:
	if skillUsed.staminaDrain < Global.stamina:
		
		#parent.store_stats()
		Global.stamina -= skillUsed.staminaDrain
		
		if parent.isESkill == true:
			parent.skillCooldown.wait_time = skillUsed.skillCooldown
			parent.skillCooldown2.wait_time = skillUsed.animationTime
			parent.skillCooldown3.wait_time = skillUsed.animationTime
			parent.cooldown.wait_time = skillUsed.animationTime
			parent.skillCooldownOff = false
			parent.skillCooldownOff2 = false
			parent.skillCooldownOff3 = false
			parent.cooldownOff = false
			#parent.canUseESkill = true
			#parent.speed = 5
			#Global.weapon = 1
			parent.skillCooldown.start()
			parent.skillCooldown2.start()
			parent.skillCooldown3.start()
			parent.cooldown.start()
			
			print("E cooldown started")
		elif parent.isQSkill == true:
			parent.skillCooldown.wait_time = skillUsed.animationTime
			parent.skillCooldown2.wait_time = skillUsed.skillCooldown
			parent.skillCooldown3.wait_time = skillUsed.animationTime
			parent.cooldown.wait_time = skillUsed.animationTime
			parent.cooldownOff = false
			parent.skillCooldownOff = false
			parent.skillCooldownOff2 = false
			parent.skillCooldownOff3 = false
			parent.canUseQSkill = true
			#await get_tree().create_timer(timeInEffect).timeout
			#parent.speed = 5
			parent.skillCooldown.start()
			parent.skillCooldown2.start()
			parent.skillCooldown3.start()
			parent.cooldown.start()
			
			print("Q cooldown started")
			
		elif parent.isRSkill == true:
			parent.skillCooldown.wait_time = skillUsed.animationTime
			parent.skillCooldown2.wait_time = skillUsed.animationTime
			parent.skillCooldown3.wait_time = skillUsed.skillCooldown
			parent.cooldown.wait_time = skillUsed.animationTime
			parent.cooldownOff = false
			parent.skillCooldownOff = false
			parent.skillCooldownOff2 = false
			parent.skillCooldownOff3 = false
			parent.skillCooldown.start()
			parent.skillCooldown2.start()
			parent.skillCooldown3.start()
			parent.cooldown.start()

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
