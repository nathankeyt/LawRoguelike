extends State

@export var charge_time = 1.0

@onready var flying_state: State = get_parent().get_node("Flying")


func on_enter_state():
	body.animation_player.play("charge")
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(body.get_node("MainSprite"), "modulate", Color.RED, charge_time)
	tween.tween_callback(change_state.emit.bind(flying_state))
