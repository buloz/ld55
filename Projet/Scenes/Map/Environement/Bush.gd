extends Node2D


func setRandomTexture():
	var index = randi() % 4
	
	match index:
		0:
			$Sprite2D.texture = preload("res://Ressources/environement/Arbuste.png")
		1:
			$Sprite2D.texture = preload("res://Ressources/environement/Herbe.png")
		2:
			$Sprite2D.texture = preload("res://Ressources/environement/herbe02.png")
		3:
			$Sprite2D.texture = preload("res://Ressources/environement/herbe03.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.material.set_shader_parameter("randValue", randf())
	setRandomTexture()
