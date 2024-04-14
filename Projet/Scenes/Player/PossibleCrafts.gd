class_name PossibleCrafts extends Node

var possibleCrafts: Array = [
	#Materials -> 0rock, 1bone, 2herb, 3wood, 4shroom
	#Summon types -> 0golem, 1ghoul, 2skelleton, 3haunt
	#SummonInfoClass -> type: int, spellType:int, health: float, damage: float, cooldown: float, range: float, confortDistance: float
	[[0, 2], SummonInfo.new(0, 0, 100, 10, 6, 800, 20)],
	[[0, 2, 3], SummonInfo.new(0, 1, 150, 15, 8, 250, 80)],
	[[0, 2, 4], SummonInfo.new(0, 2, 80, 5, 3, 800, 300)],
	[[2, 4], SummonInfo.new(1, 3, 40, 1, 5, 800, 600)],
	[[2, 4, 1], SummonInfo.new(1, 4, 100, 10, 8, 800, 20)],
	[[2, 4, 4], SummonInfo.new(1, 5, 80, 35, 2, 20, 20)],
	[[1, 2], SummonInfo.new(2, 6, 40, 25, 5, 800, 600)],
	[[1, 2, 3], SummonInfo.new(2, 7, 40, 2, 2.5, 500, 300)],
	[[1, 2, 0], SummonInfo.new(2, 8, 80, 20, 1, 20, 20)],
	[[4, 1], SummonInfo.new(3, 9, 60, 20, 15, 200, 200)],
	[[4, 1, 3], SummonInfo.new(3, 10, 30, 30, 1, 1000, 600)],
	[[4, 1, 0], SummonInfo.new(3, 11, 60, 15, 2.5, 200, 100)]
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

