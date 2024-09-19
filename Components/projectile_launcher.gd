extends Node2D
	
func fire_projectile(projectile_scene: Resource, target_pos: Vector2, projectile_speed: float, spawn_distance: float, parent: Node2D) -> void:
	var new_projectile: Node2D = projectile_scene.instantiate()
	parent.get_parent().add_child(new_projectile)
		
	var projectile_forward: Vector2 = (target_pos - parent.position).normalized()
	new_projectile.fire(projectile_forward, projectile_speed)
	new_projectile.position = parent.position + (projectile_forward * spawn_distance)
	
func fire_aerial(projectile_scene: Resource, target_pos: Vector2, projectile_speed: float, spawn_distance: float, parent: Node2D) -> void:
	var new_aerial: Node2D = projectile_scene.instantiate()
	parent.get_parent().add_child(new_aerial)
	
	var projectile = new_aerial.get_node("AerialProjectile")
	
	projectile.position.y -= spawn_distance
	projectile.fire_at_target(projectile_speed)
	new_aerial.position = target_pos
	
