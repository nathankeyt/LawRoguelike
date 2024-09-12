extends CharacterBody2D


@export var speed: float = 150.0
@export var animation_tree: AnimationTree
@export var default_projectile_scene: Resource
@export var spirit_projectile_scene: Resource

var last_direction: Vector2 = Vector2.DOWN
var spirit_power: int = 3;


func _physics_process(delta: float) -> void:
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * speed
		animation_tree.set("parameters/WalkCycle/blend_position", direction)
		last_direction = direction;
	else:
		animation_tree.set("parameters/WalkCycle/blend_position", last_direction * 0.5);
		velocity.y = move_toward(velocity.y, 0, speed)
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		fire_projectile(default_projectile_scene)
	if event.is_action_pressed("alt_fire"):
		fire_spirit_projectile(spirit_projectile_scene)

func fire_projectile(projectile_scene: Resource):
	var new_projectile: Area2D = projectile_scene.instantiate()
	get_parent().add_child(new_projectile)
	
	print(get_viewport().get_mouse_position())
		
	var projectile_forward: Vector2 = (get_global_mouse_position() - position).normalized()
	new_projectile.fire(projectile_forward, 1000.0)
	new_projectile.position = position + (projectile_forward * 20.0);

func fire_spirit_projectile(projectile_scene: Resource):
	spirit_power -= 1;
	fire_projectile(projectile_scene);
	
	
