class_name Chunk extends Node2D

@export var targetNode: Node2D
@export var maxDistance: float
@export var chunkCell: Vector2i
@export var truePosition: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.get_process_frames () % 12 != 0:
		return
	
	if truePosition.distance_to(targetNode.position) > maxDistance:
		get_parent().dealocatedChunk(chunkCell)
		queue_free()
