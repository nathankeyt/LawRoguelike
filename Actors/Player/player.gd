extends CharacterBody2D

@export var speed: float = 150.0
@export var dash_speed: float = 300.0
@export var default_projectile_scene: Resource
@export var spirit_projectile_scene: Resource
@export var shield_scene: Resource
@export var parry_length: float = 0.25
@export var parry_speedup: float = 1.5
@export var dialogue_node: Node2D
@export var map: Node2D
@export var walk_sounds: Array[AudioStream]
@export var dash_sound: AudioStream
@export var hit_audio: AudioStream
@export var game_over: AudioStream

@onready var hud: Control = $CanvasLayer/HUD

@onready var animation_tree: AnimationTree = $AnimationTree

@onready var reload_timer: Timer = $ReloadTimer
@onready var dash_timer: Timer = $DashTimer
@onready var ghost_timer: Timer = $GhostTimer
@onready var dash_reset_timer: Timer = $DashResetTimer

@onready var character_sprite: Sprite2D = $Sprite2D
@onready var walk_timer: Timer = $WalkTimer

var last_direction: Vector2 = Vector2.DOWN
var spirit_power: int = 3;
var can_shoot: bool = true;
var is_dashing: bool = false;
var can_dash: bool = true;
var talkable_char: Node2D;
var canAct: bool = true;


signal hit;

func _ready() -> void:
	global_position = PlayerManager.get_spawn_pos()

func _process(delta: float) -> void:
	var time_left: float = reload_timer.time_left
	if time_left:
		hud.set_reload_bar_ratio((reload_timer.wait_time - time_left) / reload_timer.wait_time)
		
func _physics_process(delta: float) -> void:
	var direction: Vector2 = get_direction()
	
	var viewport_rect: Vector2 = get_viewport_rect().size
	
	
	if canAct:
		if direction:
			if is_dashing:
				walk_timer.stop()
				velocity = direction * velocity.length()
			else:
				if walk_timer.is_stopped():
					walk_timer.start()
				velocity = velocity.move_toward(direction * speed, speed)
				
			animation_tree.set("parameters/WalkCycle/blend_position", direction)
			last_direction = direction;
		elif not is_dashing:
			walk_timer.stop()
				
			animation_tree.set("parameters/WalkCycle/blend_position", last_direction * 0.5);
			velocity = velocity.move_toward(Vector2.ZERO, speed)
		
	if not ghost_timer.is_stopped() and velocity.length() <= speed:
		$GhostTimer/PostIFrameTime.start()
		ghost_timer.stop()
		
	if (global_position.x <= 8 and velocity.x < 0.0) or (global_position.x >= (viewport_rect.x - 8) and velocity.x > 0.0):
		velocity.x = 0 
		
	if (global_position.y <= 16 and velocity.y < 0.0) or (global_position.y >= (viewport_rect.y - 16)  and velocity.y > 0.0):
		velocity.y = 0
	
	if canAct:
		move_and_slide()
	else:
		walk_timer.stop()

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("alt_fire"):
		#fire_spirit_projectile(spirit_projectile_scene)
	if not canAct:
		return
		
	if event.is_action_pressed("dash"):
		dash()
		
	if event.is_action_pressed("parry"):
		parry()
		
	if event.is_action_pressed("talk"):
		talk()
		
func talk() -> void:
	if not talkable_char:
		return
		
	dialogue_node.show()
	dialogue_node.play()
	hud.hide()
	map.hide()

func end_talk() -> void:
	dialogue_node.hide()
	hud.show()
	map.show()
		
func parry() -> void:
	var shield : Node2D = shield_scene.instantiate()
	add_child(shield)
	shield.position += (get_global_mouse_position() - position).normalized() * 20.0
	$ReferencePoint.look_at(get_global_mouse_position())
	shield.rotation = $ReferencePoint.rotation
	shield.setup(parry_length, parry_speedup)
		
func get_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
		
		
func enable_bit(mask: int, index: int) -> int:
	return mask | (1 << index)

func disable_bit(mask: int, index: int) -> int:
	return mask & ~(1 << index)
	
func dash() -> void:
	var direction: Vector2 = get_direction()
	
	if direction and can_dash:
		$FootstepPlayer.stream = dash_sound
		$FootstepPlayer.play()
		velocity = direction * dash_speed
		is_dashing = true;
		can_dash = false;
		can_shoot = false;
		collision_layer = disable_bit(collision_layer, 1)
		add_to_group("invinceable")
		dash_timer.start()
		ghost_timer.start_custom()
		

func fire_spirit_projectile(projectile_scene: Resource) -> void:
	spirit_power -= 1;
	#fire_projectile(projectile_scene);
	

func _on_reload_timer_timeout() -> void:
	hud.set_reload_bar_ratio(1.0)
	can_shoot = true


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	can_shoot = true
	dash_reset_timer.start()


func _on_dash_reset_timer_timeout() -> void:
	can_dash = true


func _on_dialogue_cast_body_entered(body: Node2D) -> void:
	return 
	
	if body.is_in_group("talkable"):
		hud.talk_enable()
		talkable_char = body


func _on_dialogue_cast_body_exited(body: Node2D) -> void:
	return
	if body.is_in_group("talkable"):
		hud.talk_disable()
		talkable_char = null


func _on_hit() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(character_sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(character_sprite, "modulate", Color.WHITE, 0.1)
	
	GlobalAudioManager.play_SFX(hit_audio)
	PlayerManager.player_hit.emit()
	
	if PlayerManager.health <= 0:
		GlobalAudioManager.play_SFX(game_over);
		GlobalAudioManager.stop()
		canAct = false
		animation_tree.set("parameters/WalkCycle/blend_position", Vector2(0.0, 0.5))
		await get_tree().create_timer(1.0).timeout
		rotate(-PI/2)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file.call_deferred("res://Levels/game_over.tscn")
		return


func _on_post_i_frame_time_timeout() -> void:
	collision_layer = enable_bit(collision_layer, 1)
	remove_from_group("invinceable")


func _on_walk_timer_timeout() -> void:
	$FootstepPlayer.stream = walk_sounds.pick_random()
	$FootstepPlayer.play()
