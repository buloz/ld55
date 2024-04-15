extends Node2D

signal lose(score:int)

func _ready():
	Music.play("Theme")
	$wind.play()
	
	get_node("/root/Global").playerDead = false
	lose.connect(game_over)

func game_over(score:int):
	get_tree().paused = true
	var scene = load("res://Scenes/Menu/game_over.tscn").instantiate()
	get_parent().add_child(scene)
	get_tree().paused = false
