extends State

var skillUsed : Node
var enoughStamina : bool
var LCooldownChanged : bool
var ECooldownChanged : bool
var QCooldownChanged : bool
var RCooldownChanged : bool
var isBuff : bool = true
var isHeal : bool = false

#consume more stamina for higher level skills
func check_skill() -> void:
	skillUsed = parent.skill_dict[parent.lastSkill].instantiate()
	parent.skillUsed = skillUsed
	if skillUsed.staminaDrain < Global.stamina:
		enoughStamina = true
		match skillUsed.type:
			"melee":
				state_machine.change_state("melee")
			"buff":
				state_machine.change_state("buff")
				isBuff = true
				parent.particleColour = skillUsed.colour
			"ranged":
				state_machine.change_state("ranged")
	else:
		state_machine.change_state("idle")
			
	get_tree().current_scene.add_child(skillUsed)
	
	
func enter() -> void:
	#skillUsed = parent.base.instantiate()
	enoughStamina = false
	LCooldownChanged = false
	RCooldownChanged = false
	QCooldownChanged = false
	ECooldownChanged = false

func exit() -> void:
	if enoughStamina:
		
		Global.stamina -= skillUsed.staminaDrain
		
		# only change the skill's cooldown if it isn't already in cooldown
		#if skillUsed.animationTime > parent.skillCooldown.time_left:
			#parent.skillCooldown.wait_time = skillUsed.animationTime
			#ECooldownChanged = true
		#if skillUsed.animationTime > parent.skillCooldown2.time_left:
			#parent.skillCooldown2.wait_time = skillUsed.animationTime
			#QCooldownChanged = true
		#if skillUsed.animationTime > parent.skillCooldown3.time_left:
			#parent.skillCooldown3.wait_time = skillUsed.animationTime
			#RCooldownChanged = true
		#if skillUsed.animationTime > parent.cooldown.time_left:
			#parent.cooldown.wait_time = skillUsed.animationTime
			#LCooldownChanged = true
		
		if isBuff:
			if parent.isESkill == true:
				parent.EIsBuff = true
			elif parent.isQSkill == true:
				parent.QIsBuff = true
			elif parent.isRSkill == true:
				parent.RIsBuff = true
			isBuff = false
			
			
		if parent.isESkill == true:
			parent.isESkill = false
			# only change the skill's cooldown if it isn't already in cooldown
			if skillUsed.animationTime > parent.skillCooldown.time_left:
				#parent.skillCooldown.wait_time = skillUsed.animationTime
				parent.skillCooldown.wait_time = skillUsed.skillCooldown
				parent.skillCooldownOff = false
				ECooldownChanged = true
		elif parent.isQSkill == true:
			parent.isQSkill = false
			if skillUsed.animationTime > parent.skillCooldown2.time_left:
				parent.skillCooldown2.wait_time = skillUsed.animationTime
				QCooldownChanged = true
				parent.skillCooldown2.wait_time = skillUsed.skillCooldown
				parent.skillCooldownOff2 = false
		elif parent.isRSkill == true:
			parent.isRSkill = false
			if skillUsed.animationTime > parent.skillCooldown3.time_left:
				parent.skillCooldown3.wait_time = skillUsed.animationTime
				RCooldownChanged = true
				parent.skillCooldown3.wait_time = skillUsed.skillCooldown
				parent.skillCooldownOff3 = false
		else:
			parent.cooldownOff = false
			if skillUsed.animationTime > parent.cooldown.time_left:
				parent.cooldown.wait_time = skillUsed.animationTime
				LCooldownChanged = true
				
		
		if ECooldownChanged:
			if parent.EIsBuff:
				parent.EIsBuff = false
				await get_tree().create_timer(skillUsed.timeInEffect).timeout
				parent.skillCooldown.start()
			else:
				parent.skillCooldown.start()
		if QCooldownChanged:
			if parent.QIsBuff:
				parent.QIsBuff = false
				await get_tree().create_timer(skillUsed.timeInEffect).timeout
				parent.skillCooldown2.start()
			else:
				parent.skillCooldown2.start()
		if RCooldownChanged:
			if parent.RIsBuff:
				parent.RIsBuff = false
				await get_tree().create_timer(skillUsed.timeInEffect).timeout
				parent.skillCooldown3.start()
			else:
				parent.skillCooldown3.start()
		if LCooldownChanged:
			parent.cooldown.start()


func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
