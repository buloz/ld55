extends Node2D

@export var summonScene: PackedScene

@export var spawnTargetNode: Node2D

func _ready():
	top_level = true

func spawnSummon(position: Vector2):
	var newSummon: Summon = summonScene.instantiate() 
	
	newSummon.position = position
	
	spawnTargetNode.add_child(newSummon)
