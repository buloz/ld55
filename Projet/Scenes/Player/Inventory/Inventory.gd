extends CanvasLayer

#Note: If gathering order has an importance, change the datastructure type
var storedMaterials: PackedInt32Array

var floatingMaterials: Array[int]

@onready var UI = get_node("/root/DebugScene/UI")

signal inventoryUpdate(material:int, quantity:int)
signal materialOnCooldown(material:int, cooldown:float)

var possibleCrafts: PossibleCrafts = preload("res://Scenes/Player/Inventory/PossibleCrafts.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	storedMaterials.resize(get_node("/root/Global").nbMaterials)
	UI.slotbar.connect(_slotbar_pressed)
	set_pentagram(false)

func _process(_delta):
	$pentagram.global_position = get_viewport().get_mouse_position()

func set_pentagram(b : bool):
	$pentagram.visible = b
	$pentagram/AudioStreamPlayer.playing = b

#Materials -> 0rock, 1bone, 2herb, 3wood, 4shroom
func addMaterial(materialType: int, quantity: int):
	if materialType >= storedMaterials.size():
		print("Unknown material type")
		return
	
	storedMaterials[materialType] += quantity
	
	inventoryUpdate.emit(materialType, storedMaterials[materialType])

func _slotbar_pressed(value, toggled_on):
	if toggled_on:
		if storedMaterials[value] > 0:
			floatingMaterials.append(value)
			set_pentagram(possibleCrafts.getCraftResult(floatingMaterials) != null)
		else:
			UI.slotbarReset(value)
	else:
		var index = floatingMaterials.rfind(value)
		if index > -1 and not toggled_on:
			floatingMaterials.remove_at(index)
			
			set_pentagram(!(floatingMaterials.is_empty() or not possibleCrafts.getCraftResult(floatingMaterials)))


func try_craft():
	var recipe = possibleCrafts.getCraftResult(floatingMaterials)
	if recipe:
		for item in floatingMaterials:
			storedMaterials[item] -= 1
			#TODO: ADD CD
			inventoryUpdate.emit(item, storedMaterials[item])
			materialOnCooldown.emit(item, get_parent().materialCdr)
			
	floatingMaterials.clear()
	for slot in UI.slots:
		slot.set_pressed_no_signal(false)
	
	set_pentagram(false)
	
	return recipe
