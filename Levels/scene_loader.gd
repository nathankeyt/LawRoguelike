extends Area2D

@export var scene: String;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("load scene")
		PlayerManager.store_last_pos(body.global_position)
		get_tree().change_scene_to_file(scene)
