class_name Hotbar extends HBoxContainer

signal slotbar(slot_name, state)

func toggle(id: int, toggled_on: bool):
	slotbar.emit(id, toggled_on)
	$AudioStreamPlayer.play()

func _on_slot_5_toggled(toggled_on):
	toggle(0, toggled_on)

func _on_slot_6_toggled(toggled_on):
	toggle(1, toggled_on)

func _on_slot_7_toggled(toggled_on):
	toggle(2, toggled_on)

func _on_slot_8_toggled(toggled_on):
	toggle(3, toggled_on)

func _on_slot_9_toggled(toggled_on):
	toggle(4, toggled_on)
