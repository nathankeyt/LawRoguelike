extends Control

@export var spirit_bar: TextureProgressBar;
@export var reload_bar: TextureProgressBar;

func set_reload_bar_ratio(ratio: float) -> void:
	reload_bar.ratio = ratio
	
func set_spirit_bar_ratio(ratio: float) -> void:
	spirit_bar.ratio = ratio
