extends CharacterBody2D

@export var animation_tree: AnimationTree

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	#velocity.x = 10.0
	
	#animation_tree.set("parameters/WalkCycle/blend_position", velocity.length())

	move_and_slide()
