
extends Node


var targetNode: Node2D
var chunkSize: Vector2

@export var environementSpawner: EnvironementSpawner
@export var chunkScene: PackedScene


#Cell in which the camera entered
#var exploredCell: Dictionary = {}

#Cell that got loaded
var loadedCell: Dictionary = {}


func dealocatedChunk(chunkPosition: Vector2i):
	loadedCell.erase(chunkPosition)
	#exploredCell.erase(chunkPosition)

func getChunksFromRectMask(targetCell: Vector2i):
	var chunks: Array[Vector2i] = []
	for y in range(-1, 2):
		for x in range(-1, 2):
			chunks.append(Vector2i(targetCell.x + x, targetCell.y + y))
	
	return chunks

func explore():
	var targetCell: Vector2i = (targetNode.position / chunkSize).floor()
	
	#if targetCell in exploredCell:
		#return
	
	#Insert new target node cell in explored cell
	#exploredCell[targetCell] = null
	
	var chunksToLoad: Array[Vector2i] = getChunksFromRectMask(targetCell)
	
	for chunk in chunksToLoad:
		
		if chunk in loadedCell:
			continue
			
		#Create
		var newChunkNode: Chunk = chunkScene.instantiate()
		newChunkNode.targetNode = targetNode
		newChunkNode.maxDistance = 6000
		newChunkNode.chunkCell = chunk
		newChunkNode.truePosition = Vector2(chunk) * chunkSize + chunkSize / 2.0

		
		loadedCell[chunk] = newChunkNode
		
		environementSpawner.generate(chunk, newChunkNode)
		
		add_child(newChunkNode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.get_process_frames () % 12 != 0:
		return
	
	explore()
