class_name PossibleCrafts extends Node

var possibleCrafts: Array = [
	#Materials -> 0: rock, 1: bone, 2: herb, 3: wood, 4: shroom
	#Summon types -> 0golem, 1ghoul, 2skelleton, 3haunt
	#SummonInfoClass -> type, subtype, spellType, health, damage, cooldown, range, confortDistance
	[[0, 2], SummonInfo.new(0, 0, 0, 300, 40, 2, 800, 400, 400)], #Golem Thumble
	[[0, 2, 3], SummonInfo.new(0, 1, 1, 250, 35, 1.5, 300, 250, 400)], #Golem shockwave
	[[0, 2, 4], SummonInfo.new(0, 2, 2, 150, 20, 1, 800, 500, 400)], #GolemCrumbs
	
	[[2, 4], SummonInfo.new(1, 0, 3, 50, 25, 0.75, 800, 600, 550)], #GhoulSpit
	[[2, 4, 1], SummonInfo.new(1, 1, 4, 150, 40, 1.5, 800, 400, 550)], #GhoulLeap
	[[2, 4, 3], SummonInfo.new(1, 2, 5, 170, 90, 0.9, 300, 250, 550)], #GhouleMelee
	
	[[1, 2], SummonInfo.new(2, 0, 7, 80, 20, 1, 700, 400, 700)], #SkeletonMultishot
	[[1, 2, 3], SummonInfo.new(2, 1, 6, 40, 10, 0.15, 1000, 900, 700)], #SkeletonBomb
	[[1, 2, 0], SummonInfo.new(2, 2, 8, 100, 45, 0.45, 300, 250, 700)], #SkeletonMelee
	
	[[4, 1], SummonInfo.new(3, 0, 9, 120, 10, 5, 800, 300, 650)], #HauntedConjure
	[[4, 1, 3], SummonInfo.new(3, 1, 10, 20, 40, 1.0, 1200, 1150, 650)], #HauntedThunder
	[[4, 1, 0], SummonInfo.new(3, 2, 11, 80, 75, 2.0, 400, 380, 650)] #HauntedHowl
]


class CraftGraphNode:
	var isCorrect: bool
	var next: Dictionary
	var summonInfo: SummonInfo = null
	
	func _init(_isCorrect: bool, _next: Dictionary, _summonInfo: SummonInfo = null):
		self.isCorrect = _isCorrect
		self.next = _next
		self.summonInfo = _summonInfo
	

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

