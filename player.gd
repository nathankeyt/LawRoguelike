extends CharacterBody2D


@export var speed: float = 300.0
@export var animation_tree: AnimationTree;

var last_direction: Vector2 = Vector2.DOWN;


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * speed
		animation_tree.set("parameters/WalkCycle/blend_position", direction);
		last_direction = direction;
	else:
		animation_tree.set("parameters/WalkCycle/blend_position", last_direction * 0.5);
		velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
		

	move_and_slide()
