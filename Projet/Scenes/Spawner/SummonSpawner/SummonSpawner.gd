extends Node

@export var summonScene: PackedScene

func spawnSummon(position: Vector2, spell: PackedScene):
	var newSummon: Summon = summonScene.instantiate()
	
	newSummon.get_node("CasterComponent").spellScene = spell
	
	newSummon.position = position
	
	add_child(newSummon)
