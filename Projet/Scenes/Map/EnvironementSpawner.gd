
class_name EnvironementSpawner extends Node2D

var chunkSize: Vector2 

@export var environementItems: Array[PackedScene]
@export var materialScene: PackedScene

@export_range(-1.0, 1.0) var grassProbabilty: float = 0.0
@export_range(-1.0, 1.0) var materialProbabilty: float = 0.0

var noise: FastNoiseLite = FastNoiseLite.new()


func _ready():
	noise.fractal_type = 0


func generate(chunkPosition: Vector2i, parentNode: Node2D):
	
	var startPosition: Vector2 = Vector2(chunkPosition.x * chunkSize.x, chunkPosition.y * chunkSize.y)
	var endPosition: Vector2 = startPosition + chunkSize
	
	var environementItemsSize: int = environementItems.size()
	
	for i in 50:
		var spawnPosition = Vector2(randf_range(startPosition.x, endPosition.x), randf_range(startPosition.y, endPosition.y))
		
		if noise.get_noise_2dv(spawnPosition) > grassProbabilty:
			var environementIndex: int = randi() % environementItemsSize
			
			var newEnvironementItem = environementItems[environementIndex].instantiate()
			
			newEnvironementItem.position = spawnPosition
			
			parentNode.add_child(newEnvironementItem)
	
	for i in 50:
		var spawnPosition = Vector2(randf_range(startPosition.x, endPosition.x), randf_range(startPosition.y, endPosition.y))
		
		if noise.get_noise_2dv(spawnPosition) > materialProbabilty:
		
			var newMaterial = materialScene.instantiate()
			newMaterial.setRandomMaterial()
			
			newMaterial.position = spawnPosition
			
			parentNode.add_child(newMaterial)
