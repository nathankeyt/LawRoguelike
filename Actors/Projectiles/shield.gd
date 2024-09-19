extends Area2D

@onready var parry_timer: Timer = $ParryTimer
@onready var sprite: Sprite2D = $Sprite2D

var parry_speedup: float = 1.0;

func _ready() -> void:
	sprite.modulate.a = 0.0

func setup(parry_length: float, new_parry_speedup: float = 1.0):
	parry_speedup = new_parry_speedup
	
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, parry_length / 2.0).set_ease(Tween.EASE_OUT);
	tween.tween_property(sprite, "modulate:a", 0.0, parry_length / 2.0).set_ease(Tween.EASE_IN);
	parry_timer.start(parry_length);

func _on_parry_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("parryable"):
		if "target" in area:
			area.target.queue_free()
		area.velocity = area.velocity.bounce(Vector2.from_angle(rotation)) * parry_speedup
		area.look_at(area.global_position + area.velocity.normalized())
		
