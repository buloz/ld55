extends Node2D


@export_range(0, 4) var materialType: int = 0
@export_range(0, 3) var spriteLocalIndex: int = 0

@onready var spriteIndex = materialType * 4 + spriteLocalIndex

func setRandomMaterial():
	materialType = randi() % 5
	spriteLocalIndex = randi() % 4
	
	spriteIndex = materialType * 4 + spriteLocalIndex
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.frame = spriteIndex
	
	var row = materialType
	var col = spriteLocalIndex
	
	if materialType == 4:
		col = 4
		row = spriteLocalIndex
	
	$AnimatedSprite2D.material.set_shader_parameter("col", col + 1)
	$AnimatedSprite2D.material.set_shader_parameter("row", row + 1)
	$AnimatedSprite2D.material.set_shader_parameter("randValue", randf())
	
func _on_area_2d_body_entered(_body):
	get_node("/root/Global").Player.gatherMaterial(materialType, 1)
	queue_free()
