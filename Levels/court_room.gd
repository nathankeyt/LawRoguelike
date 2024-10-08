extends Node2D

@export var player: CharacterBody2D;
@export var player_pos: Node2D;
@export var dialogue_node: Node2D;
@export var map: Node2D;

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("OpeningAnimation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimerLabel.text = str($TimerLabel/SurvivalTimer.time_left).pad_decimals(2)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween: Tween = get_tree().create_tween();
		tween.tween_property(body, "global_position", player_pos.global_position, 1.0);
		player.canAct = false
		player.animation_tree.set("parameters/WalkCycle/blend_position", Vector2(0.0, -0.5));
		anim_player.play("Start")
		$Map/TableR/Area2D.body_entered.disconnect(_on_area_2d_body_entered)
		

func talk() -> void:	
	dialogue_node.show()
	dialogue_node.play()
	player.hud.hide()
	map.hide()

func end_talk() -> void:
	dialogue_node.hide()
	player.hud.show()
	map.show()
	player.canAct = true
	$TimerLabel/SurvivalTimer.start()
	$TimerLabel.show()
	$Map/Path2D/MalletSpawner.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Start":
		talk()


func _on_survival_timer_timeout() -> void:
	$Map/Path2D/MalletSpawner.stop()
	$TimerLabel.hide()
