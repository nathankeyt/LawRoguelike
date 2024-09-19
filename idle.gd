extends State

var detect_range: Area2D
var chasing_state: State

func initialize():
	detect_range = body.get_node("DetectionRange")
	chasing_state = get_parent().get_node("Chasing")
	
func process_state(delta: float):
	var bodies: Array[Node2D] = detect_range.get_overlapping_bodies()
	if not bodies.is_empty():
		print("switch to chasing")
		chasing_state.target = bodies[0]
		change_state.emit(chasing_state)
