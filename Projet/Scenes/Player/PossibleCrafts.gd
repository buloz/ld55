class_name PossibleCrafts extends Node


var SummonInfoClass = preload("res://Scenes/Entity/Summon/SummonInfo.gd")

var possibleCrafts: Array = [
	#SummonInfoClass -> type: int, health: float, damage: float, cooldown: float, range: float, confortDistance: float
	[[0, 1, 2], SummonInfoClass.new(0, 0, 0.0, 0.0, 0.0, 0.0, 0.0)],
	[[1, 2], SummonInfoClass.new(1, 4, 0.0, 0.0, 0.0, 0.0, 0.0)],
	[[4, 3], SummonInfoClass.new(2, 5, 0.0, 0.0, 0.0, 0.0, 0.0)]
]


class CraftGraphNode:
	var isCorrect: bool
	var next: Dictionary
	var summonInfo: SummonInfo = null
	
	func _init(isCorrect: bool, next: Dictionary, summonInfo: SummonInfo = null):
		self.isCorrect = isCorrect
		self.next = next
		self.summonInfo = summonInfo
	

var craftDictionary: CraftGraphNode = CraftGraphNode.new(false, {})

func recursiveAdd(currentLevel: CraftGraphNode, bufferToAdd: Array, summonInfo: SummonInfo):
	
	if bufferToAdd.is_empty():
		currentLevel.isCorrect = true
		currentLevel.summonInfo = summonInfo
		return
	
	for element in bufferToAdd:
		
		var newPlaceToAdd: CraftGraphNode
		
		if currentLevel.next.has(element):
			newPlaceToAdd = currentLevel.next[element]
		else:
			currentLevel.next[element] = CraftGraphNode.new(false, {})
			newPlaceToAdd = currentLevel.next[element]
			
		recursiveAdd(newPlaceToAdd, bufferToAdd.filter(func(filterElem): return filterElem != element), summonInfo)

func _init():
	
	for possibleCraft in possibleCrafts:
		recursiveAdd(craftDictionary, possibleCraft[0], possibleCraft[1])


func getCraftResult(floatingMaterials: Array[int]) -> SummonInfo:
	
	var currentPosition: CraftGraphNode = craftDictionary
	var lastPossibleReceip: CraftGraphNode = currentPosition
	
	for i in range(floatingMaterials.size() - 1, -1, -1):
		var currentMaterial = floatingMaterials[i]
		
		#If current material don't allow us to continue craft, skip it
		if not currentPosition.next.has(currentMaterial):
			continue
		
		currentPosition = currentPosition.next[currentMaterial]
		
		#If current graph node is a correct receip, store it
		if currentPosition.isCorrect:
			lastPossibleReceip = currentPosition
	
	if lastPossibleReceip.isCorrect:
		return lastPossibleReceip.summonInfo
		
	return null

