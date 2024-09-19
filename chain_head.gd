extends AnimatableBody2D

@onready var start_position: Vector2 = position

var can_move: bool = true
	
func _physics_process(delta: float) -> void:
	if can_move:
		position = start_position
