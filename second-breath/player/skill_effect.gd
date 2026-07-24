extends CPUParticles3D

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var particleColour : Color
@onready var player : Player = $".."

func _process(_delta: float) -> void:
	self.mesh.material.emission = color
	if emitting:
		randomize_colour()
		
func randomize_colour() -> void:
	particleColour = player.particleColour
	color = particleColour.lightened(rng.randf_range(-0.3, 0.3))
