extends Timer

@export var ghost_scene: Resource
@export var sprite: Sprite2D
@export var ghost_lifespan: = 0.5
@export var color: Color = Color.WHITE

func create_ghost() -> void:
	var ghost: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.position = get_parent().position
	
	ghost.setup(sprite, color, ghost_lifespan)
	
func start_custom():
	create_ghost()
	start()

func _on_timeout() -> void:
	create_ghost()
