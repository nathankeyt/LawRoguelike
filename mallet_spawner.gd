extends PathFollow2D

@export var mallet_scene: Resource
@export var target: Node2D;
@export var progress_rate: float = 0.01;

@onready var spawn_rate: Timer = $SpawnRate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	progress_ratio += progress_rate * delta



func _on_spawn_rate_timeout() -> void:
	var new_mallet: CharacterStateMachine = mallet_scene.instantiate()
	get_parent().add_child(new_mallet)
	
	new_mallet.position = position
	new_mallet.target = target
	
	new_mallet.start()
