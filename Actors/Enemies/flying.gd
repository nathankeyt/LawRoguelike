extends State

@export var fly_speed: float = 500.0
@export var hit_effect: Resource;


var collision_shape: CollisionShape2D;

var target: Node2D;

func initialize():
	collision_shape = body.get_node("HitRange/CollisionShape2D")

func process_state(delta: float):
	body.move_and_slide()
	
	
func on_enter_state():
	target = body.target
	var distance: Vector2 = target.position - body.position
	body.velocity = distance.normalized() * fly_speed
	body.look_at(target.position)
	
	collision_shape.disabled = false
	body.animation_player.play("fly")


func _on_hit_range_body_entered(other: Node2D) -> void:
	if other.is_in_group("invinceable"):
		return
		
	handle_collision(other)
	body.queue_free()
		
func handle_collision(other: Node2D) -> void:
	var hit_effect: GPUParticles2D = hit_effect.instantiate()
	other.emit_signal("hit")
	body.get_parent().add_child(hit_effect)
	hit_effect.position = body.global_position
	hit_effect.emitting = true

	hit_effect.look_at(body.global_position + (body.global_position - other.position).normalized())
