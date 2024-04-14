class_name MobSpawner extends Node2D


@export var mobScene: PackedScene

@export var spawnTargetNode: Node2D


var spawnBoundary: Vector2 = Vector2(1200, 2000)



func spawnMob(count: int):
	
	for i in count:
		var newMob: Mob = mobScene.instantiate()
		
		var spawnDirection: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		var spawnDistance: float = randf_range(spawnBoundary.x, spawnBoundary.y)
		
		var spawnPosition: Vector2 = get_node("/root/Global").playerPosition + spawnDirection * spawnDistance
		
		newMob.position = spawnPosition
		
		spawnTargetNode.add_child(newMob)
