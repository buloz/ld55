extends Control

@export var quitButton:BaseButton
@export var retryButton:BaseButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_pressed():
	get_tree().quit()


func _on_retry_button_pressed():
	var prevscene = get_node("/root/DebugScene/MainScene")
	prevscene.free()
	var newScene = load("res://Scenes/Menu/main_scene.tscn").instantiate()
	get_node("/root/DebugScene").add_child(newScene)
	get_node("/root/DebugScene/UI").setNewScene(newScene)
	get_parent().queue_free()
