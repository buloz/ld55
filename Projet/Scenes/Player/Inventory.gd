extends CanvasLayer

#Note: If gathering order has an importance, change the datastructure type
var storedMaterials: PackedInt32Array

var floatingMaterials: Array[int]

@onready var hotbar:Hotbar = get_node("/root/DebugScene/UI/Hotbar")

signal inventoryUpdate(material:int, quantity:int)

var possibleCrafts: PossibleCrafts = preload("res://Scenes/Player/PossibleCrafts.gd").new()

#Mouse cursor
var mouseSummonCursor = preload("res://Ressources/cursor/summonCursor.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	storedMaterials.resize(get_node("/root/Global").nbMaterials)
	hotbar.slotbar.connect(_slotbar_pressed)
	set_pentagram(false)

func _process(_delta):
	var mp := get_viewport().get_mouse_position()
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
			hotbar.get_node("Slot%d" % (5 + value)).button_pressed = false
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
			inventoryUpdate.emit(item, storedMaterials[item])
	floatingMaterials.clear()
	for slot in get_node("/root/DebugScene/UI/Hotbar").get_children(true):
		if slot is BaseButton:
			slot.set_pressed_no_signal(false)
	
	set_pentagram(false)
	
	return recipe
