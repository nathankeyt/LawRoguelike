extends State

@export var chase_speed: float = 100.0
@export var target_spacing: float = 100.0


var target: Node2D;

var charging_state: State;


func initialize():
	charging_state = get_parent().get_node("Charging")

func process_state(delta: float):
	print(target.name)
	var distance: Vector2 = target.position - body.position
	body.velocity = distance.normalized() * chase_speed
	body.move_and_slide()
	
	if distance.length() < target_spacing:
		change_state.emit(charging_state)
		
func on_enter_state():
	target = body.target
	body.animation_player.play("walk")
