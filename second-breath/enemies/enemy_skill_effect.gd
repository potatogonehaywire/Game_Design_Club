extends GPUParticles3D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var particleColour : Color
@onready var enemy : Enemy = $".."

func _process(_delta: float) -> void:
	self.draw_pass_1.material.emission = draw_pass_1.material.albedo_color
	if emitting:
		randomize_colour()
		
func randomize_colour() -> void:
	particleColour = enemy.particleColour
	draw_pass_1.material.albedo_color = particleColour.lightened(rng.randf_range(-0.3, 0.3))
