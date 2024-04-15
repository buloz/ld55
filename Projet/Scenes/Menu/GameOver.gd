extends CanvasLayer

@export var quitButton:BaseButton
@export var retryButton:BaseButton

var score:Array

func _ready():
	$UI/QuitButton.pressed.connect(quit)
	$UI/RetryButton.pressed.connect(retry)
	$ScoreHolder/Score.text = "Ennemies:\n" + str(score[1])
	$ScoreHolder/Time.text = "Time undead:\n" + str(round(score[0])) + " s"
	
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
