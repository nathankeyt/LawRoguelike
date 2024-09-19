extends CharacterBody2D

@export var animation_tree: AnimationTree
@export var shoot_projectile_scene: Resource
@export var aerial_scene: Resource
@export var player: CharacterBody2D
@export var projectile_speed: float = 250.0
@export var aerial_speed: float = 100.0

@onready var projectile_launcher: Node2D = $ProjectileLauncher

var shoot_aerial: bool = false

func _physics_process(delta: float) -> void:
	
	#velocity.x = 10.0
	
	#animation_tree.set("parameters/WalkCycle/blend_position", velocity.length())

	move_and_slide()

func _on_shoot_timer_timeout() -> void:
	if shoot_aerial:
		projectile_launcher.fire_aerial(aerial_scene, player.position, projectile_speed, 100.0, self)
	else:
		projectile_launcher.fire_projectile(shoot_projectile_scene, player.position, projectile_speed, 40.0, self)
	shoot_aerial = !shoot_aerial
