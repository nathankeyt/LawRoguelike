extends CharacterStateMachine

@export var shoot_projectile_scene: Resource
@export var shoot_projectile_scene2: Resource
@export var aerial_scene: Resource
@export var player: CharacterBody2D
@export var projectile_speed: float = 250.0
@export var aerial_speed: float = 100.0
@export var is_aggro: bool = false
@export var chain_attack: AudioStream
@export var aerial_attack: AudioStream
@export var normal_attack: AudioStream
@export var health_bar: TextureProgressBar
@export var max_health: int
@export var hit_sound: AudioStream

@onready var projectile_launcher: Node2D = $ProjectileLauncher
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var health = max_health

var shoot_aerial: bool = false
var shoot_chain: bool = false

signal phase_end
signal boss_hit

func _process(delta: float) -> void:
	animation_tree.set("parameters/WalkCycle/blend_position", velocity.length())
	
func attack():
	$ShootTimer.start()
	is_aggro = true
	health_bar.show()

func _on_shoot_timer_timeout() -> void:
	if shoot_aerial:
		GlobalAudioManager.play_SFX(aerial_attack)
		projectile_launcher.fire_aerial(aerial_scene, player.position, aerial_speed, 100.0, self)
		shoot_aerial = false
	else:
		if shoot_chain:
			GlobalAudioManager.play_SFX(chain_attack)
			projectile_launcher.fire_projectile(shoot_projectile_scene, player.position, projectile_speed, 40.0, self)
		else:
			GlobalAudioManager.play_SFX(normal_attack)
			projectile_launcher.fire_projectile(shoot_projectile_scene2, player.position, projectile_speed, 50.0, self)
	shoot_chain = !shoot_chain

func reset():
	health = 3
	health_bar.value = 3
	
func stop():
	is_aggro = false
	current_state = $States/Idle

func _on_boss_hit() -> void:
	health -= 1
	health_bar.value -= 1
	
	GlobalAudioManager.play_SFX(hit_sound)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.1)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1)
	
	if health <= 0:
		phase_end.emit()
