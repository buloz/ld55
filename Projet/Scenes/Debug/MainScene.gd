extends Node2D

signal lose(score:Array)

func _ready():
	
	get_node("/root/Global").currentMainScene = self
	
	Music.play("Theme")
	$wind.play()
	$dong.play()
	
	get_node("/root/Global").playerDead = false
	lose.connect(game_over)
	
func game_over(score:Array):
	get_tree().paused = true
	var scene = load("res://Scenes/Menu/game_over.tscn").instantiate()
	scene.score = score
	get_parent().add_child(scene)
	get_node("/root/DebugScene/UI").visible = false
	get_tree().paused = false
