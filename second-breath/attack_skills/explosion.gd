extends Area3D

@onready var eradius = $explosionRadius

func _ready() -> void:
	self.eradius.shape.radius = 0.1

func _process(_delta: float) -> void:
	if self.eradius.shape.radius <= 1:
		self.eradius.shape.radius += 0.015

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("upon_hit"): 
		var id = body.id
		Global.enemyHitID.insert(0, id)
		print(Global.enemyHitID)
		Global.enemyIsHit = true
	elif body.is_in_group("player"):
		Global.health -= 10 + Global.debuff
