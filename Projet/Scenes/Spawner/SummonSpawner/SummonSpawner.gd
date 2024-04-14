extends Node2D

@export var summonScene: PackedScene

@export var spawnTargetNode: Node2D

func _ready():
	top_level = true

func spawnSummon(position: Vector2, spell: PackedScene):
	var newSummon: Summon = summonScene.instantiate()
	
	newSummon.get_node("CasterComponent").spellScene = spell
	
	newSummon.position = position
	
	spawnTargetNode.add_child(newSummon)
