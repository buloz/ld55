extends Node

@export var summonScene: PackedScene

func spawnSummon(position: Vector2):
	var newSummon: Summon = summonScene.instantiate() 
	
	newSummon.position = position
	
	add_child(newSummon)
