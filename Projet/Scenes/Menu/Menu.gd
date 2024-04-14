extends Node2D

const mainScene := preload("res://Scenes/Debug/DebugScene.tscn")

var selected = null

func _ready():
	var os_name := OS.get_name()
	if os_name == "HTML5":
		$UI/Quit.queue_free()
	
	$UI/Play/Sprite2D.hide()
	$UI/Quit/Sprite2D.hide()
	
	Music.play("Intro")
	$AnimationPlayer.play("intro")

func start_game():
	print("MENU: Start game")
	set_process_input(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	tween.tween_callback(get_tree().change_scene_to_packed.bind(mainScene))

func quit():
	print("MENU: Quit")
	get_tree().quit()

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
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		accept()
