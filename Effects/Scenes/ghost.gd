extends Sprite2D

@onready var time_to_live: Timer = $TimeToLive

func setup(sprite: Sprite2D, new_color: Color, lifespan: float = 0.5) -> void:
	texture = sprite.texture
	vframes = sprite.vframes
	hframes = sprite.hframes
	frame = sprite.frame
	modulate = new_color
	
	time_to_live.wait_time = lifespan;
	start()

func start() -> void:
	var tween: Tween = get_tree().create_tween()
	
	tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, time_to_live.wait_time).set_ease(Tween.EASE_IN)
	time_to_live.start()

func _on_time_to_live_timeout() -> void:
	queue_free()
