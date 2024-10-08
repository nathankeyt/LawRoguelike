extends AudioStreamPlayer2D

signal sfx_finished

func play_track(new_stream: AudioStream, volume = 1.0):
	if (stream == new_stream):
		return
		
	stream = new_stream
	volume_db = volume
	play()
	
func play_SFX(new_stream: AudioStream, volume = 1.0, length = 0.0):
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = new_stream
	sfx_player.volume_db = volume
	sfx_player.name = "SFX_Instance"
	add_child(sfx_player)
	sfx_player.play()
	
	if length:
		await get_tree().create_timer(length).timeout
		sfx_finished.emit()
		sfx_player.queue_free()
	else:
		await sfx_player.finished
		sfx_finished.emit()
		sfx_player.queue_free()
