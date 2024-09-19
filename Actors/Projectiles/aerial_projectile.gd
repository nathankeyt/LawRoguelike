extends Area2D

@export var hit_effect: Resource
@export var target: Area2D

var velocity: Vector2 = Vector2(0, 0)

func fire_at_target(speed: float) -> void:
	var forward: Vector2 = (target.position - position).normalized()
	fire(forward, speed)

func fire(forward: Vector2, speed: float) -> void:
	scale_target()
	get_parent().show()
	velocity = forward * speed
	look_at(position + forward)
	
func _process(delta: float) -> void:
	scale_target()
	
func scale_target() -> void:
	if is_instance_valid(target):
		var distance: float = (target.position - position).length() / 100.0
		target.get_node("Sprite2D").scale = Vector2(distance, distance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("invinceable"):
		return
		
	if is_instance_valid(target):
		for other: Node2D in target.get_overlapping_bodies():
			if body == other:
				handle_collision(body)
	else:
		handle_collision(body)
			
func handle_collision(body: Node2D) -> void:
	var hit_effect: GPUParticles2D = hit_effect.instantiate()
	get_parent().get_parent().add_child(hit_effect)
	hit_effect.position = global_position
	hit_effect.emitting = true
	#hit_effect.look_at(position - Vector2.from_angle(rotation))
	hit_effect.look_at(global_position+ (global_position - body.position).normalized())

	get_parent().queue_free()	
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("aerial_target"):
		get_parent().queue_free()


func _on_time_to_live_timeout() -> void:
	queue_free()
