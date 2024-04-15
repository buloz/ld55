extends CanvasLayer

@export var quitButton:BaseButton
@export var retryButton:BaseButton

func _ready():
	$UI/QuitButton.pressed.connect(quit)
	$UI/RetryButton.pressed.connect(retry)
	
	Music.play("Death")

func _out_anim(callback: Callable):
	var t := create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property($front, "position:y", 324, 2.0)
	t.tween_callback(callback)

func quit():
	_out_anim(get_tree().change_scene_to_file.bind("res://Scenes/Menu/Menu.tscn"))

func retry():
	_out_anim(get_tree().reload_current_scene)
