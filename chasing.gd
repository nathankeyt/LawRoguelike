extends State

@export var chase_speed: float = 100.0

var target: Node2D;

func process_state(delta: float):
	body.velocity = (target.position - body.position).normalized() * chase_speed
	body.move_and_slide()
