extends Label

func _ready():
	if !OS.has_feature("editor"):
		get_parent().queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var fps = Engine.get_frames_per_second()
	text = "FPS: " + str(fps)
