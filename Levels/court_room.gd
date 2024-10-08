extends Node2D

@export var player: CharacterBody2D;
@export var boss: CharacterStateMachine;
@export var player_pos: Node2D;
@export var start_dialogue_node: Node2D;
@export var mid_dialogue_node: Node2D;
@export var last_dialogue_node: Node2D;
@export var map: Node2D;
@export var court_music: AudioStream;
@export var battle_music: AudioStream;
@export var timeout_sound: AudioStream;

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var active_dialogue: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudioManager.play_track(court_music, 1.0)
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
		
		

func talk(dialogue: Node2D) -> void:	
	dialogue.show()
	dialogue.play()
	active_dialogue = dialogue
	player.hud.hide()
	map.hide()

func end_talk() -> void:
	active_dialogue.hide()
	player.hud.show()
	map.show()
	player.canAct = true
	
	if active_dialogue == start_dialogue_node:
		GlobalAudioManager.play_track(battle_music)
		$TimerLabel/SurvivalTimer.start()
		$TimerLabel.show()
		$Map/Path2D/MalletSpawner.start()
	elif active_dialogue == mid_dialogue_node:
		boss.attack()
	else:
		boss.attack()
		$Map/Path2D/MalletSpawner.start()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Start":
		talk(start_dialogue_node)


func _on_survival_timer_timeout() -> void:
	$Map/Path2D/MalletSpawner.stop()
	$TimerLabel.hide()
	GlobalAudioManager.play_SFX(timeout_sound)
	await GlobalAudioManager.sfx_finished
	talk(mid_dialogue_node)
	
func _on_boss_1_phase_end() -> void:
	if active_dialogue == last_dialogue_node:
		$Map/Path2D/MalletSpawner.stop()
		boss.stop()
		GlobalAudioManager.stop()
		await get_tree().create_timer(1.0).timeout
		boss.rotate(-PI/2)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file.call_deferred("res://Levels/win.tscn")
		return
	
	boss.reset()
	boss.global_position = $Map/BossPos.global_position
	await get_tree().create_timer(1.0).timeout
	talk(last_dialogue_node)
