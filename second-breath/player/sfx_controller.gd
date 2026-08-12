extends Node3D
const WALK_DIRT : AudioStreamMP3 = preload("uid://dqnrbupchyth6")
const WALK_GRASS : AudioStreamMP3 = preload("uid://daawdw8r4tddi")
const WALK_GRASS_2 : AudioStreamMP3 = preload("uid://ckey55svboy30")
@onready var player_state_machine: StateMachine = $"../PlayerStateMachine"
@onready var walking_audio: AudioStreamPlayer3D = $Walking
@onready var attack_audio: AudioStreamPlayer3D = $Attack
@onready var player: Player = $".."


var walking_sounds : Array = [WALK_DIRT, WALK_GRASS, WALK_GRASS_2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_state_machine.state_changed.connect(change_audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_audio(state : String) -> void:
	match state:
		"walk":
			if player.is_on_floor():
				walking_audio.stream = walking_sounds[randi_range(0,2)]
				walking_audio.play()
			else:
				walking_audio.stop()
		"melee":
			attack_audio.play()


func _on_walking_finished() -> void:
	walking_audio.stream = walking_sounds[randi_range(0,2)]
	walking_audio.play()
