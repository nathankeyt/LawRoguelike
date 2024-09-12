extends CharacterBody2D

@export var animation_tree: AnimationTree
@export var shoot_projectile_scene: Resource
@export var player: CharacterBody2D
@export var projectile_speed: float = 250.0

func _physics_process(delta: float) -> void:
	
	#velocity.x = 10.0
	
	#animation_tree.set("parameters/WalkCycle/blend_position", velocity.length())

	move_and_slide()

func fire_projectile(projectile_scene: Resource, target_pos: Vector2) -> void:
	var new_projectile: Area2D = projectile_scene.instantiate()
	get_parent().add_child(new_projectile)
		
	var projectile_forward: Vector2 = (target_pos - position).normalized()
	new_projectile.fire(projectile_forward, projectile_speed)
	new_projectile.position = position + (projectile_forward * 40.0)


func _on_shoot_timer_timeout() -> void:
	fire_projectile(shoot_projectile_scene, player.position)
