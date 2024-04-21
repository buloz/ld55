extends Node

@onready var joystick_base_state := {}

func _input(event):
	var finger_count = joystick_base_state.size()
	if finger_count == 0 and event is InputEventScreenDrag:
		joystick_base_state = { event.index: event.position }
	if finger_count == 1:
		if event is InputEventScreenTouch and joystick_base_state.has(event.index):
			if !event.pressed:
				for action in ["move_left", "move_right", "move_down", "move_up"]:
					Input.action_release(action)
					joystick_base_state.erase(event.index)
				get_viewport().set_input_as_handled()
		#drag procs movement actions
		elif event is InputEventScreenDrag:
			if joystick_base_state.has(event.index):
				var output = Vector2(event.position.x - joystick_base_state[event.index].x, event.position.y - joystick_base_state[event.index].y)
				#move_right
				if output.x > 10:
					Input.action_release("move_left")
					Input.action_press("move_right", output.x)
				#move_left
				elif output.x < 10:
					Input.action_release("move_right")
					Input.action_press("move_left", -output.x)
				#move_down
				if output.y > 10:
					Input.action_release("move_up")
					Input.action_press("move_down", output.y)
				#move_up
				elif output.y < 10:
					Input.action_release("move_down")
					Input.action_press("move_up", -output.y)
				get_viewport().set_input_as_handled()
