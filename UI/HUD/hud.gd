extends Control

@export var spirit_bar: TextureProgressBar
@export var reload_bar: TextureProgressBar
@export var talk_tip_label: RichTextLabel
@export var talk_tip_text: String = ""
@export var health_bar: TextureProgressBar


func _ready() -> void:
	PlayerManager.player_hit.connect(_on_player_hit)
	#talk_tip_label.text = "Press to talk"

func set_reload_bar_ratio(ratio: float) -> void:
	reload_bar.ratio = ratio
	
func set_spirit_bar_ratio(ratio: float) -> void:
	spirit_bar.ratio = ratio

func talk_enable():
	talk_tip_label.text = talk_tip_text % InputMap.action_get_events("talk")[0].as_text().split(' ')[0]
	talk_tip_label.show()
	
func talk_disable():
	talk_tip_label.hide()


func _on_player_hit() -> void:
	health_bar.value -= 1
