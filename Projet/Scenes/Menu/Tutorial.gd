extends CanvasLayer

@onready var tabs = [$one, $two]
var current = 0

func _ready():
	hide_tutorial()

func _set_tutorial(b : bool):
	visible = b
	set_process_input(b)
	get_tree().paused = b
	current = -1

func hide_tutorial():
	_set_tutorial(false)

func show_tutorial():
	_set_tutorial(true)
	next()

func next():
	for tab in tabs:
		tab.visible = false
	
	current += 1
	if current == tabs.size():
		hide_tutorial()
	else:
		tabs[current].visible = true

func _input(event):
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		next()
