extends Area3D

@onready var eradius = $explosionRadius

func _ready() -> void:
	self.eradius.shape.radius = 0.1

func _process(_delta: float) -> void:
	if self.eradius.shape.radius <= 0.75:
		self.eradius.shape.radius += 0.01
#func explosionCheck():
	#await get_tree().physics_frame
	#
	## 2. Query the direct space state
	#var space_state = get_world_3d().direct_space_state
	#var query = PhysicsShapeQueryParameters3D.new()
	#query.shape = $CollisionShape3D.shape
	#query.transform = global_transform
	#
	## 3. Filter to only detect desired bodies (Optional)
	#query.collision_mask = collision_mask 
	#
	## 4. Perform the check
	#var results = space_state.intersect_shape(query)
	#print("Entities in area: ", results.size())
	#return results

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("upon_hit"): 
		var id = body.id
		Global.enemyHitID.insert(0, id)
		print(Global.enemyHitID)
		Global.enemyIsHit = true
