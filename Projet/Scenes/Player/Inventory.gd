extends Node


#Note: If gathering order has an importance, change the datastructure type
var storedMaterials: PackedInt32Array


# Called when the node enters the scene tree for the first time.
func _ready():
	storedMaterials.resize(get_node("/root/Global").nbMaterials)


func addMaterial(materialType: int, quantity: int):
	
	if materialType >= storedMaterials.size():
		print("Bug, unknown material type")
		return
	
	storedMaterials[materialType] += quantity
	
	print("New inventory: ", storedMaterials)

