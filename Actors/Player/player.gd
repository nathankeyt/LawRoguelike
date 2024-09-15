extends CharacterBody2D

@export var speed: float = 150.0
@export var dash_speed: float = 300.0
@export var default_projectile_scene: Resource
@export var spirit_projectile_scene: Resource
@export var shield_scene: Resource;
@export var parry_length: float = 0.25;
@export var parry_speedup: float = 1.5;
@export var dialogue_node: Node2D;
@export var map: Node2D;

@onready var hud: Control = $CanvasLayer/HUD

@onready var animation_tree: AnimationTree = $AnimationTree

@onready var reload_timer: Timer = $ReloadTimer
@onready var dash_timer: Timer = $DashTimer
@onready var ghost_timer: Timer = $GhostTimer
@onready var dash_reset_timer: Timer = $DashResetTimer

@onready var character_sprite: Sprite2D = $Sprite2D

var last_direction: Vector2 = Vector2.DOWN
var spirit_power: int = 3;
var can_shoot: bool = true;
var is_dashing: bool = false;
var can_dash: bool = true;
var talkable_char: Node2D;

func _process(delta: float) -> void:
	var time_left: float = reload_timer.time_left
	if time_left:
		hud.set_reload_bar_ratio((reload_timer.wait_time - time_left) / reload_timer.wait_time)
		
	
		

func _physics_process(delta: float) -> void:
	var direction: Vector2 = get_direction()
	
	if direction:
		if is_dashing:
			velocity = direction * velocity.length()
		else:
			velocity = velocity.move_toward(direction * speed, speed)
			
		animation_tree.set("parameters/WalkCycle/blend_position", direction)
		last_direction = direction;
	elif not is_dashing:
		animation_tree.set("parameters/WalkCycle/blend_position", last_direction * 0.5);
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		
	if not ghost_timer.is_stopped() and velocity.length() <= speed:
		remove_from_group("invinceable")
		ghost_timer.stop()
		
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and can_shoot:
		fire_projectile(default_projectile_scene)
		
	#if event.is_action_pressed("alt_fire"):
		#fire_spirit_projectile(spirit_projectile_scene)
		
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
	dialogue_node.set_text("Wowza, haven't had visitors here in a while!")
	dialogue_node.play()
	hud.hide()
	map.hide()
	
		
func parry() -> void:
	var shield = shield_scene.instantiate()
	add_child(shield)
	shield.position += (get_global_mouse_position() - position).normalized() * 20.0
	shield.look_at(get_global_mouse_position())
	shield.setup(parry_length, parry_speedup)
		
func get_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
		
func dash() -> void:
	var direction: Vector2 = get_direction()
	
	if direction and can_dash:
		velocity = direction * dash_speed
		is_dashing = true;
		can_dash = false;
		can_shoot = false;
		add_to_group("invinceable")
		dash_timer.start()
		ghost_timer.start_custom()
		


func fire_projectile(projectile_scene: Resource) -> void:
	can_shoot = false;
	hud.set_reload_bar_ratio(0.0)
	reload_timer.start()
	
	var new_projectile: Area2D = projectile_scene.instantiate()
	get_parent().add_child(new_projectile)
	
	print(get_viewport().get_mouse_position())
		
	var projectile_forward: Vector2 = (get_global_mouse_position() - position).normalized()
	new_projectile.fire(projectile_forward, 1000.0)
	new_projectile.position = position + (projectile_forward * 20.0)

func fire_spirit_projectile(projectile_scene: Resource) -> void:
	spirit_power -= 1;
	fire_projectile(projectile_scene);
	

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
	if body.is_in_group("talkable"):
		hud.talk_enable()
		talkable_char = body


func _on_dialogue_cast_body_exited(body: Node2D) -> void:
	if body.is_in_group("talkable"):
		hud.talk_disable()
		talkable_char = null
