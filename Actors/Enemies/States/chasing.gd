extends State

@export var chase_speed: float = 100.0
@export var target_spacing: float = 100.0


var idle_state: State;
var target: Node2D;

func initialize():
	idle_state = get_parent().get_node("Idle")

func process_state(delta: float):
	var distance: Vector2 = target.position - body.position
	body.velocity = distance.normalized() * chase_speed
	body.move_and_slide()
	
	if distance.length() < target_spacing:
		change_state.emit(idle_state)
