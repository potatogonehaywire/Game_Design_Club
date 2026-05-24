extends State
class_name EnemyBuff
var skillUsed : Node

func apply_buffs() -> void:
	parent.enemyhp += skillUsed.healthChange
	parent.debuff = skillUsed.debuff
	parent.dmgdebuff = skillUsed.dmgDebuff
	parent.enemyMaxHp = skillUsed.maxHealth
	parent.damage = parent.BASE_DAMAGE * (skillUsed.weaponBuff + 1)
	parent.speed += skillUsed.speedBuff
	parent.health_bar.health_changed()
	#parent.skill_effect.mesh.material.emission = skillUsed.colour
	#parent.skill_effect.emitting = true
	
	
func enter() -> void:
	skillUsed = parent.skillUsed
	apply_buffs()
	print("enemy buffed", parent.lastSkill)
	state_machine.change_state("pursuit")


func exit() -> void:
	pass

func update(_delta:float) -> void:
	pass

func physics_update(_delta:float) -> void:
	pass
