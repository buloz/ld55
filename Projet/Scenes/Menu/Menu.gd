extends Node2D

const mainScene := preload("res://Scenes/Debug/DebugScene.tscn")

var selected = null

func _ready():
	
	$ScreenFilter/ScreenFilterRect.hideFilter(true)
	
	if OS.get_name() == "HTML5":
		$UI/Quit.queue_free()
	
	unselect()
	
	Music.play("Intro")
	$AnimationPlayer.play("intro")
	$AnimationPlayer.animation_finished.connect(set_rain)

func set_rain(_anim: String):
	Music.play("Rain")

func start_game():
	print("MENU: Start game")
	set_process_input(false)
	
	$ScreenFilter/ScreenFilterRect.start(false, get_tree().change_scene_to_packed.bind(mainScene))

func quit():
	print("MENU: Quit")
	get_tree().quit()

func unselect():
	selected = null
	$UI/Play/Sprite2D.hide()
	$UI/Quit/Sprite2D.hide()

func select(obj, anim : String):
	if selected == obj:
		return
	print("MENU: Selected '" + anim + "'")
	selected = obj
	$UI/AnimationPlayer.play(anim)

func accept():
	if selected == $UI/Play:
		start_game()
	elif selected == $UI/Quit:
		quit()

func _input(event):
	##debug helper
	if event is InputEventKey and event.physical_keycode == KEY_INSERT:
		start_game()
	
	if event.is_action_pressed("ui_up"):
		select($UI/Play, "select_play")
	elif event.is_action_pressed("ui_down"):
		select($UI/Quit, "select_quit")
	elif event.is_action_pressed("ui_accept"):
		accept()
	elif event is InputEventMouseMotion:
		if $UI/Play.is_hovered():
			select($UI/Play, "select_play")
		elif $UI/Quit.is_hovered():
			select($UI/Quit, "select_quit")
		else:
			unselect()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		accept()
