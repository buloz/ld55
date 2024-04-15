extends Node2D

@export var targetNode: Node2D
@export var chunkSize: Vector2 = Vector2(2000, 2000)


func _ready():
	$ChunkHandler.targetNode = targetNode
	
	$ChunkHandler.chunkSize = chunkSize
	$EnvironementSpawner.chunkSize = chunkSize
