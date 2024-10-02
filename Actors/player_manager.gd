extends Node

var health: int = 3
var last_pos: Vector2;

signal player_hit

func _ready() -> void:
	last_pos = get_viewport().get_final_transform().get_origin()
	PlayerManager.player_hit.connect(_on_player_hit)

func _on_player_hit() -> void:
	print("hit")
	health -= 1;
	
	if health < 1:
		get_tree().reload_current_scene()
		
func store_last_pos(pos: Vector2):
	last_pos = pos

func get_spawn_pos() -> Vector2:
	var center: Vector2 = get_viewport().get_final_transform().get_origin()
	var forward: Vector2 = (center - last_pos)
	
	if abs(forward.x) < abs(forward.y):
		forward.x = 0.0
	else:
		forward.y = 0.0
	
	return last_pos + (forward * 1.9)
	
