extends State

var skillUsed : Node
var enoughStamina : bool
var LCooldownChanged : bool
var ECooldownChanged : bool
var QCooldownChanged : bool
var RCooldownChanged : bool

#consume more stamina for higher level skills
#not alloweed to use 2 skills at once ?
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
		
		parent.cooldownOff = false
		parent.skillCooldownOff = false
		parent.skillCooldownOff2 = false
		parent.skillCooldownOff3 = false
		
		# only change the skill's cooldown if it isn't already in cooldown
		if skillUsed.animationTime > parent.skillCooldown.time_left:
			parent.skillCooldown.wait_time = skillUsed.animationTime
			ECooldownChanged = true
		if skillUsed.animationTime > parent.skillCooldown2.time_left:
			parent.skillCooldown2.wait_time = skillUsed.animationTime
			QCooldownChanged = true
		if skillUsed.animationTime > parent.skillCooldown3.time_left:
			parent.skillCooldown3.wait_time = skillUsed.animationTime
			RCooldownChanged = true
		if skillUsed.animationTime > parent.cooldown.time_left:
			parent.cooldown.wait_time = skillUsed.animationTime
			LCooldownChanged = true
			
		if parent.isESkill == true:
			parent.skillCooldown.wait_time = skillUsed.skillCooldown
			parent.isESkill = false
		elif parent.isQSkill == true:
			parent.skillCooldown2.wait_time = skillUsed.skillCooldown
			parent.isQSkill = false
		elif parent.isRSkill == true:
			parent.skillCooldown3.wait_time = skillUsed.skillCooldown
			parent.isRSkill = false
		
		if ECooldownChanged:
			parent.skillCooldown.start()
		if QCooldownChanged:
			parent.skillCooldown2.start()
		if RCooldownChanged:
			parent.skillCooldown3.start()
		if LCooldownChanged:
			parent.cooldown.start()


func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
