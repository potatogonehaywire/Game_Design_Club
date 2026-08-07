extends RigidBody3D
@onready var sprite_3d: Sprite3D = $Sprite3D
const ANGER_ESSENCE_1 : CompressedTexture2D = preload("uid://dopje6qwnhsgh")
const ENVY_ESSENCE_3 : CompressedTexture2D = preload("uid://d2mhs6tc4rnmh")
const FEAR_ESSENCE_2 : CompressedTexture2D= preload("uid://ilotdg810pn8")

var type : String = "anger"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func change_type(enemy_type : String) -> void:
	type = enemy_type
	match enemy_type:
		"anger":
			sprite_3d.texture = ANGER_ESSENCE_1
		"fear":
			sprite_3d.texture = FEAR_ESSENCE_2
		"envy":
			sprite_3d.texture = ENVY_ESSENCE_3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)
	

func _on_pickup_area_area_entered(_area: Area3D) -> void:
	Global.collected_fragments[type] += 1
	self.queue_free()
