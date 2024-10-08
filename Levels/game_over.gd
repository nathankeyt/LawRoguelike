extends Node2D

@export var scene: String
@export var game_over: AudioStream

func _ready() -> void:
	GlobalAudioManager.play_track(game_over)

func _on_quit_button_up() -> void:
	get_tree().quit()


func _on_restart_button_up() -> void:
	PlayerManager.reset()
	get_tree().change_scene_to_file.call_deferred(scene)
