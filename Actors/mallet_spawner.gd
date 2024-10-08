extends PathFollow2D

@export var mallet_scene: Resource
@export var target: Node2D;
#@export var progress_rate_center: float = 0.01;

@onready var spawn_rate: Timer = $SpawnRate

var mallet_list: Array[CharacterBody2D]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	progress_ratio = randf_range(0.0, 1.0)

func start():
	spawn_rate.start()
	
func stop():
	for mallet in mallet_list:
		if is_instance_valid(mallet):
			mallet.queue_free()
	spawn_rate.stop()

func _on_spawn_rate_timeout() -> void:
	var new_mallet: CharacterStateMachine = mallet_scene.instantiate()
	get_parent().add_child(new_mallet)
	
	new_mallet.position = position
	new_mallet.target = target
	
	new_mallet.start()
	mallet_list.append(new_mallet)
