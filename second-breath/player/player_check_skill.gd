extends State


func check_skill() -> void:
	match parent.lastSkill:
		1: #basic anger
			Global.health -= 10
			Global.debuff = 5
			state_machine.change_state("melee")
		2: #basic fear
			state_machine.change_state("ranged")
		3: #basic envy
			Global.dmgdebuff = 3
			state_machine.change_state("melee")
		4: #max level anger
			Global.debuff = 8
			Global.health -= 20
			state_machine.change_state("melee")
		5: #max level fear
			parent.explodes = true
			Global.debuff = -10.0 * Global.ranged
			state_machine.change_state("ranged")
		6: #max level envy
			Global.debuff = -2
			state_machine.change_state("melee")

		7: #anger/fear hybrid
			Global.maxHealth = 180
			state_machine.change_state("melee")
			#Global.weapon += 2, reverse after cooldown.. Global thing for speed and multiply character speed in player script by the global thing
		8: #fear/envy
			state_machine.change_state("ranged")
			#make bom go boom but no dmg but debuff
		9: #anger/envy
			state_machine.change_state("melee")
			#Strong buffs(atk+hp) and debuff every enemy you hit(reduce enemy atk)
		_:
			state_machine.change_state("melee")

	
func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
