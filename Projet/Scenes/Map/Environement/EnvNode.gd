extends Node2D

func _ready():
	$AnimatedSprite2D.material.set_shader_parameter("randValue", randf())
	$AnimatedSprite2D.frame = randi() % $AnimatedSprite2D.sprite_frames.get_frame_count("default")
