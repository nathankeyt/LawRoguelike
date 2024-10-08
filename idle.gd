extends State

@export var min_distance: float = 150.0

var detect_range: Area2D
var chasing_state: State

func initialize():
	detect_range = body.get_node("DetectionRange")
	chasing_state = get_parent().get_node("Chasing")
	
func process_state(delta: float):
	if body.is_aggro:
		var bodies: Array[Node2D] = detect_range.get_overlapping_bodies()
		for target: Node2D in bodies:
			if target.is_in_group("targetable") and (target.position - body.position).length() > min_distance:
				chasing_state.target = target
				change_state.emit(chasing_state)

func on_enter_state():
	body.velocity = Vector2.ZERO
