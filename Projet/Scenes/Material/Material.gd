extends Node2D

@export var type: int

func _on_area_2d_body_entered(_body):
	get_node("/root/Global").Player.gatherMaterial(type, 1)
	queue_free()
