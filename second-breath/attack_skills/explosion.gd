extends Area3D

@onready var eradius = $explosionRadius
var isEnemy = false

func _ready() -> void:
	if Global.skillType == 5:
		self.eradius.shape.radius = 1
	if Global.skillType == 8:
		self.eradius.shape.radius = 0.75
	else:
		self.eradius.shape.radius = 0.5

func _process(_delta: float) -> void:
	if Global.skillType == 5:
		if self.eradius.shape.radius <= 1.75:
			self.eradius.shape.radius += 0.05
	elif Global.skillType == 8:
		if self.eradius.shape.radius <= 1.15:
			self.eradius.shape.radius += 0.05
	elif self.eradius.shape.radius <= 1:
		self.eradius.shape.radius += 0.05

func _on_body_entered(body: Node3D) -> void:
	if Global.skillType == 5:
		if body.has_method("upon_hit"): 
			var id = body.id
			Global.enemyHitID.insert(0, id)
			print(Global.enemyHitID)
			Global.enemyIsHit = true
	elif Global.skillType == 8:
		pass
		Global.dmgdebuff = 3
	else:
		if body.has_method("upon_hit"): 
			var id = body.id
			Global.enemyHitID.insert(0, id)
			print(Global.enemyHitID)
			Global.enemyIsHit = true
		elif body.is_in_group("player"):
			Global.health -= 10 + Global.debuff
