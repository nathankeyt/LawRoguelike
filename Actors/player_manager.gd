extends Node

var health: int = 3
var last_pos: Vector2;
var viewport_rect: Rect2;


signal player_hit

func set_viewport_rect(rect: Rect2):
	viewport_rect = rect
	last_pos = viewport_rect.get_center()

func reset() -> void:
	health = 3

func _ready() -> void:
	reset()
	PlayerManager.player_hit.connect(_on_player_hit)

func _on_player_hit() -> void:
	print("hit")
	health -= 1;
		
		
func store_last_pos(pos: Vector2):
	last_pos = pos

func get_spawn_pos() -> Vector2:
	var center: Vector2 = viewport_rect.get_center()
	var forward: Vector2 = (center - last_pos)
	
	if abs(forward.x) < abs(forward.y):
		forward.x = 0.0
	else:
		forward.y = 0.0
	
	return last_pos + (forward * 1.9)
	
