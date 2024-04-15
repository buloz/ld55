extends Node2D


func setRandomTexture():
	var index = randi() % 2
	
	match index:
		0:
			$Sprite2D.texture = preload("res://Ressources/environement/Arbrev1.png")
		1:
			$Sprite2D.texture = preload("res://Ressources/environement/Arbrev2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.material.set_shader_parameter("randValue", randf())
	setRandomTexture()
