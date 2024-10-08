extends Node2D

@export var scene: String

func _on_start_button_up() -> void:
	get_tree().change_scene_to_file.call_deferred(scene)


func _on_quit_button_up() -> void:
	get_tree().quit()
