extends Node

#Note: If gathering order has an importance, change the datastructure type
var storedMaterials: PackedInt32Array

var floatingMaterials: Array[int]

@onready var hotbar:Hotbar = get_node("/root/DebugScene/UI/Hotbar")


var possibleCrafts: PossibleCrafts = preload("res://Scenes/Player/PossibleCrafts.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready():
	storedMaterials.resize(get_node("/root/Global").nbMaterials)
	hotbar.slotbar.connect(_slotbar_pressed)
	
	var isPossible = possibleCrafts.getCraftResult([5, 2, 3])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([1, 0])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([3, 4])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([4, 3])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([4, 3])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([1, 0, 2])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([2, 0, 1])
	print(isPossible)
	
	isPossible = possibleCrafts.getCraftResult([5, 2, 0, 1, 2])
	print(isPossible)
	
	pass

func addMaterial(materialType: int, quantity: int):
	if materialType >= storedMaterials.size():
		print("Unknown material type")
		return
	
	storedMaterials[materialType] += quantity
	
	print("New inventory: ", storedMaterials)

func _slotbar_pressed(value, toggled_on):
	if toggled_on:
		if storedMaterials[value] > 0:
			floatingMaterials.append(value)
	else:
		var index = floatingMaterials.rfind(value)
		if index > -1 and !toggled_on:
			floatingMaterials.remove_at(index)

func _input(event):
	if floatingMaterials.size() > 0 and event.is_action_pressed("primary_action"):
		_try_craft(floatingMaterials)

func _try_craft(materials):
	#if materials is Array[int]:
	pass
