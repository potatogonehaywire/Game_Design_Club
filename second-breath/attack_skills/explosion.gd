extends Area3D
@onready var explosion_sprite: Sprite3D = $Sprite3D
@onready var eradius : CollisionShape3D = $explosionRadius
var isEnemy : bool = false
var explosionType : int = 0

func _ready() -> void:
	if explosionType == 5:
		self.eradius.shape.radius = 1
	if explosionType == 8:
		self.eradius.shape.radius = 0.75
	else:
		self.eradius.shape.radius = 0.5

func _process(_delta: float) -> void:
	if explosionType == 5:
		if self.eradius.shape.radius <= 1.75:
			explosion_sprite.scale += Vector3(3, 3, 3)
			self.eradius.shape.radius += 0.05
	elif explosionType == 8:
		if self.eradius.shape.radius <= 1.15:
			explosion_sprite.scale += Vector3(3, 3, 3)
			self.eradius.shape.radius += 0.05
	elif self.eradius.shape.radius <= 1:
		explosion_sprite.scale += Vector3(3, 3, 3)
		self.eradius.shape.radius += 0.05

func _on_body_entered(body: Node3D) -> void:
	if explosionType == 5:
		if body.has_method("upon_hit"): 
			var id : int = body.id
			Global.enemyHitID.insert(0, id)
			print(Global.enemyHitID)
			Global.enemyIsHit = true
	elif explosionType == 8:
		Global.dmgdebuff = 3
	else:
		if body.has_method("upon_hit"): 
			var id : int = body.id
			Global.enemyHitID.insert(0, id)
			print(Global.enemyHitID)
			Global.enemyIsHit = true
		elif body.is_in_group("player"):
			Global.health -= 10 + Global.debuff

func get_explosion_type(skillType : int) -> void:
	explosionType = skillType
