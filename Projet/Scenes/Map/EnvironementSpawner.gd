
class_name EnvironementSpawner extends Node2D

var chunkSize: Vector2 

@export var environementItem: PackedScene
@export var treeItems: PackedScene
@export var materialScene: PackedScene

@export_range(-1.0, 1.0) var grassProbabilty: float = 0.0
@export_range(-1.0, 1.0) var treeProbabilty: float = 0.0
@export_range(-1.0, 1.0) var materialProbabilty: float = 0.0

var noise: FastNoiseLite = FastNoiseLite.new()


func _ready():
	noise.seed = randf()
	noise.fractal_type = 0
	noise.frequency = 0.0005


func generate(chunkPosition: Vector2i, parentNode: Node2D):
	
	var startPosition: Vector2 = Vector2(chunkPosition.x * chunkSize.x, chunkPosition.y * chunkSize.y)
	var endPosition: Vector2 = startPosition + chunkSize
	
	var biome: float = (noise.get_noise_2dv(startPosition) + 1.0) / 2.0 
	
	var bushSpawn: int = 50
	var treeSpawn: int = 50
	var materialSpawn: int = 30
	
	if biome < 0.33:
		bushSpawn = 10
		treeSpawn = 75
	elif biome < 0.66:
		pass
	else:
		bushSpawn = 75
		treeSpawn = 10
	
	
	for i in bushSpawn:
		var spawnPosition = Vector2(randf_range(startPosition.x, endPosition.x), randf_range(startPosition.y, endPosition.y))
		
		if randf() > grassProbabilty:			
			var newEnvironementItem = environementItem.instantiate()
			
			newEnvironementItem.position = spawnPosition
			
			parentNode.add_child(newEnvironementItem)
	
	for i in materialSpawn:
		var spawnPosition = Vector2(randf_range(startPosition.x, endPosition.x), randf_range(startPosition.y, endPosition.y))
		
		if randf() > materialProbabilty:
		
			var newMaterial = materialScene.instantiate()
			newMaterial.setRandomMaterial()
			
			newMaterial.position = spawnPosition
			
			parentNode.add_child(newMaterial)
	
	
	for i in treeSpawn:
		var spawnPosition = Vector2(randf_range(startPosition.x, endPosition.x), randf_range(startPosition.y, endPosition.y))
		
		#if noise.get_noise_2dv(spawnPosition) > treeProbabilty:
		if randf() > treeProbabilty:
			var newTreeItem = treeItems.instantiate()
			
			newTreeItem.position = spawnPosition
			
			parentNode.add_child(newTreeItem)
