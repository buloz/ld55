extends CanvasLayer

func _ready():
	$Tutorial.exit_tutorial.connect(reactivate_button)
	set_process_input(true)

func _on_texture_button_pressed():
	$TutorialButton.disabled = true
	$Tutorial.show_tutorial()

func reactivate_button():
	$TutorialButton.disabled = false

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		$Tutorial.hide_tutorial()
