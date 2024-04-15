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

#Materials -> 0rock, 1bone, 2herb, 3wood, 4shroom
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

func try_craft():
	var recipe = possibleCrafts.getCraftResult(floatingMaterials)
	if recipe:
		for item in floatingMaterials:
			storedMaterials[item] -= 1
	floatingMaterials.clear()
	for slot in get_node("/root/DebugScene/UI/Hotbar").get_children(true):
		if slot is BaseButton:
			slot.set_pressed_no_signal(false)
	return recipe
