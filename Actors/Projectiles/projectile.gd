extends Area2D

@export var hit_effect: Resource;

var velocity: Vector2 = Vector2(0, 0)

func fire(forward: Vector2, speed: float) -> void:
	velocity = forward * speed;
	look_at(position + forward);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_time_to_live_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("invinceable"):
		return

	var hit_effect: GPUParticles2D = hit_effect.instantiate()
	get_parent().add_child(hit_effect)
	hit_effect.position = position
	hit_effect.emitting = true
	#hit_effect.look_at(position - Vector2.from_angle(rotation))
	hit_effect.look_at(position + (position - body.position).normalized())
	
	queue_free()
