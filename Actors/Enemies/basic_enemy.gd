extends CharacterStateMachine

@export var target: Node2D;

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start():
	current_state.start()
