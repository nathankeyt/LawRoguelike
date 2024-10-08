extends Node2D

@export var start_music: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudioManager.play_track(start_music, 10.0)
