extends State


func check_skill() -> void:
	match parent.lastSkill:
		1: #basic anger
			#parent.healthDrain = true
			Global.health -= 10
			Global.debuff = 5
			state_machine.change_state("melee")
		2: #basic fear
			state_machine.change_state("ranged")
		3: #basic envy
			Global.dmgdebuff = 3
			#parent.skillCooldown.start(1)
			state_machine.change_state("melee")
		4: #max level anger
			#parent.healthDrain = true
			Global.debuff = 8
			Global.health -= 20
			state_machine.change_state("melee")
			#parent.skillCooldown.start(1)
		5: #max level fear
			parent.explodes = true
			Global.debuff = -10.0 * Global.ranged
			state_machine.change_state("ranged")
			#parent.skillCooldown.start(1)
		6: #max level envy
			pass
			Global.debuff = -2
			state_machine.change_state("melee")
			#parent.skillCooldown.start(1)
		7: #anger/fear hybrid
			Global.maxHealth = 180
			state_machine.change_state("melee")
			#parent.skillCooldown.start(1)
			#Global.weapon += 2, reverse after cooldown.. Global thing for speed and multiply character speed in player script by the global thing
		8: #fear/envy
			state_machine.change_state("ranged")
			#parent.skillCooldown.start(1)
			#make bom go boom but no dmg but debuff
		9: #anger/envy
			state_machine.change_state("melee")
			#parent.skillCooldown.start(1)
			#Strong buffs(atk+hp) and debuff every enemy you hit(reduce enemy atk)
		_:
			state_machine.change_state("melee")
	#use_skill()

#func use_skill() -> void:
	#if parent.healthDrain == true:
		#if Global.skillType == 1:
			#Global.health -= 10
		#if Global.skillType == 4:
			#Global.health -= 20
			#print (Global.health)
			#parent.healthDrain = false
	#Global.enemyIsHit = true
	#if parent.explodes == true:
		#explode()

#func explode() -> void:
	#var explosion_instance : Node = explosion.instantiate()
	#add_child(explosion_instance)
	#explosion_instance.global_position = self.global_position
	#Global.debuff = 0
	#await get_tree().create_timer(1).timeout
	#explosion_instance.queue_free()
	
func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta:float) -> void:
	check_skill()

func physics_update(_delta:float) -> void:
	pass
