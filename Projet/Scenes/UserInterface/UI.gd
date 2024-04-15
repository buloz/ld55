extends CanvasLayer

func _ready():
	$Tutorial.exit_tutorial.connect(reactivate_button)
	set_process_input(true)
	var player = get_parent().get_tree().get_first_node_in_group("player")
	player.tutoStep.connect(updateText)
	player.get_node("Inventory").inventoryUpdate.connect(updateSlotTooltip)
	$Label.text = "Gather materials by walking over it."

func setNewScene(scene:Node2D):
	var player = scene.get_node("Player")
	#player.tutoStep.connect(updateText)
	var inventory = player.get_node("Inventory")
	inventory.inventoryUpdate.connect(updateSlotTooltip)
	for index in inventory.storedMaterials.size():
		updateSlotTooltip(index, inventory.storedMaterials[index])
	#$Label.text = "Gather materials by walking over it."

func _on_texture_button_pressed():
	$TutorialButton.disabled = true
	$Tutorial.show_tutorial()

func reactivate_button():
	$TutorialButton.disabled = false

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		$Tutorial.hide_tutorial()

func updateText(value:String):
	if value.is_empty():
		$Label.queue_free()
	$Label.text = value

func updateSlotTooltip(material:int, quantity:int):
	match material:
		0:
			$Hotbar.get_node("Slot5").get_node("Label").text = str(quantity)
		1:
			$Hotbar.get_node("Slot6").get_node("Label").text = str(quantity)
		2:
			$Hotbar.get_node("Slot7").get_node("Label").text = str(quantity)
		3:
			$Hotbar.get_node("Slot8").get_node("Label").text = str(quantity)
		4:
			$Hotbar.get_node("Slot9").get_node("Label").text = str(quantity)
