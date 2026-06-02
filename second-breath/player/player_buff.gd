extends State
var skillUsed : Node

func apply_buffs() -> void:
	Global.health += skillUsed.healthChange
	Global.debuff += skillUsed.debuff
	Global.dmgdebuff = skillUsed.dmgDebuff
	Global.maxHealth = skillUsed.maxHealth
	Global.weapon = skillUsed.weaponBuff
	parent.speed += skillUsed.speedBuff
	parent.health_bar.health_changed()
	parent.skill_effect.mesh.material.emission = skillUsed.colour
	parent.skill_effect.emitting = true

func enter() -> void:
	skillUsed = parent.skillUsed
	apply_buffs()

func exit() -> void:
	await get_tree().create_timer(skillUsed.timeInEffect).timeout
	parent.skill_effects_clear()
	Global.weapon -= skillUsed.weaponBuff
	skillUsed.queue_free()

func update(_delta:float) -> void:
	# check if player is pressing WASD
	var hDirection : float = Input.get_axis("left", "right")
	var vDirection : float= Input.get_axis("forward", "backward")
	
	if Input.is_action_just_pressed("skill") && parent.skillCooldownOff == true:
		parent.lastSkill = parent.ESkill
		parent.isESkill = true
		state_machine.change_state("checkskill")

	if Input.is_action_just_pressed("skill2") && Global.stamina > 10 && parent.skillCooldownOff2 == true:
		parent.lastSkill = parent.QSkill
		parent.isQSkill = true
		state_machine.change_state("checkskill")
	
	if Input.is_action_just_pressed("attack") && Global.stamina > 10 && parent.cooldownOff == true:
		parent.lastSkill = parent.LSkill
		state_machine.change_state("checkskill")
	
	if Input.is_action_just_pressed("skill3") && Global.stamina > 10 && parent.skillCooldownOff3 == true:
		parent.lastSkill = parent.RSkill
		parent.isRSkill = true
		state_machine.change_state("checkskill")
	
	if Input.is_action_just_pressed("jump") && parent.jump >= 1 && Global.stamina >= 15:
		state_machine.change_state("jump")
	
	if hDirection != 0 or vDirection != 0:
		state_machine.change_state("walk")
		
		
func physics_update(_delta:float) -> void:
	pass
