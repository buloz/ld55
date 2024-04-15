extends Node2D

signal lose(score:int)

func _ready():
	lose.connect(game_over)
	
func game_over(score:int):
	get_tree().paused = true
	var scene = load("res://Scenes/Menu/game_over.tscn").instantiate()
	get_parent().add_child(scene)
	get_tree().paused = false
