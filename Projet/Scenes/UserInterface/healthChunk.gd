extends Panel

func _ready():
	shake()

func shake():
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_OUT)
	$sprite.rotation = signf(randf() - 0.5) * PI/12
	t.tween_property($sprite, "rotation", 0.0, 0.1 + randf() * 0.3)
	t.tween_interval(randf_range(10.0, 30.0))
	t.tween_callback(shake)

func update(value:int):
	$sprite.frame = value
