extends CanvasLayer

signal slotbar(slot_name, state)

@onready var tutoLabel = preload("res://Scenes/UserInterface/tutoLabel.tscn")
@onready var slots := $Hotbar.get_children()

func _ready():
	var player = get_parent().get_tree().get_first_node_in_group("player")
	player.tutoStep.connect(updateText)
	player.get_node("Inventory").inventoryUpdate.connect(updateSlotTooltip)
	player.get_node("DamageReceiver").healthUpdated.connect($HealthBar.updateHealthPoint)
	
	$Tutorial.exit_tutorial.connect(reactivate_button)
	$TutoPanel/Label.text = "Gather materials by walking over it."
	$HealthBar.setMaxHealth(player.get_node("HealthComponent").MaxHealth)
	
	for i in slots.size():
		slots[i].toggled.connect(slotbarToggle.bind(i))
	
	set_process_input(true)

func setNewScene(scene:Node2D):
	var player = scene.get_node("Player")
	var inventory = player.get_node("Inventory")
	inventory.inventoryUpdate.connect(updateSlotTooltip)
	for index in inventory.storedMaterials.size():
		updateSlotTooltip(index, inventory.storedMaterials[index])
	if($Label):
		add_child(tutoLabel.instantiate())
		player.tutoStep.connect(updateText)
		$Label.text = "Gather materials by walking over it."
	var healthComponent = player.get_node("HealthComponent")
	$HealthBar.setMaxHealth(healthComponent.MaxHealth)
	$HealthBar.updateHealthPoint(healthComponent.currentHealth)
	player.get_node("DamageReceiver").healthUpdated.connect($HealthBar.updateHealthPoint)
	visible = true

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
		$TutoPanel.queue_free()
	$TutoPanel/Label.text = value

func slotbarReset(id: int):
	slots[id].button_pressed = false

func slotbarToggle(toggled_on: bool, id: int):
	slotbar.emit(id, toggled_on)
	$SlotbarClick.play()

func updateSlotTooltip(material:int, quantity:int):
	slots[material].set_quantity(quantity)
