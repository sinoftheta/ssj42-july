extends Label

func _process(delta:float) -> void:
	visible = Options.show_fps
	text = "fps: " + str(Engine.get_frames_per_second())
