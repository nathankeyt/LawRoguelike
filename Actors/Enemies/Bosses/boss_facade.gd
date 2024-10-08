extends PathFollow2D

@export var walk_duration: float = 1.0
@export var wait_time: float = 1.0

func _init() -> void:
	if EnemyManager.mainSceneFacade:
		queue_free()
	else:
		EnemyManager.mainSceneFacade = true

func _ready() -> void:
	var start_timer = $StartTimer
	start_timer.wait_time = wait_time
	start_timer.start()

func _on_start_timer_timeout() -> void:
	$AnimationPlayer.play("walk")
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "progress_ratio", 1.0, walk_duration)
