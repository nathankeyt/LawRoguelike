extends Area2D

@export var hit_effect: Resource
@export var active_time: float = 3.0

@onready var lifespan: Timer = $TimeToLive
@onready var chain_end: AnimatableBody2D = $Chain.get_node("ChainEnd")

var chain_range: float
var chain_target: Node2D

var velocity: Vector2 = Vector2(0, 0)

func _ready() -> void:
	chain_range = chain_end.position.length()

func fire(forward: Vector2, speed: float) -> void:	
	velocity = forward * speed
	look_at(position + forward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta
	if chain_target:
		chain_end.global_position = chain_target.global_position
		var relative_target_pos: Vector2 = chain_target.global_position - global_position
		if relative_target_pos.length()	 > chain_range:
			chain_target.global_position = global_position + (relative_target_pos.normalized() * chain_range)
			


func _on_time_to_live_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("invinceable") or chain_target:
		return
		
	if body.is_in_group("targetable"):
		lifespan	.stop()
		lifespan.wait_time = active_time
		lifespan.start()
		velocity = Vector2.ZERO
		chain_end.can_move = false
		chain_target = body

	var hit_effect: GPUParticles2D = hit_effect.instantiate()
	get_parent().add_child(hit_effect)
	hit_effect.position = position
	hit_effect.emitting = true
	#hit_effect.look_at(position - Vector2.from_angle(rotation))
	hit_effect.look_at(position + (position - body.position).normalized())
