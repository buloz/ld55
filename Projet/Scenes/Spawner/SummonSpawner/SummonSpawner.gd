extends Node2D

@export var summonScene: PackedScene

@export var spawnTargetNode: Node2D

func _ready():
	top_level = true

func spawnSummon(position: Vector2, info: SummonInfo):
	var newSummon: Summon = summonScene.instantiate()
	
	newSummon.initializeFromInfo(info)
	
	newSummon.position = position
	
	spawnTargetNode.add_child(newSummon)
	
	var summonSound := $SummonSound.duplicate()
	newSummon.add_child(summonSound)
	summonSound.play()
