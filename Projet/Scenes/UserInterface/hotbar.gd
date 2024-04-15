class_name Hotbar extends HBoxContainer

signal slotbar(slot_name, state)

func _on_slot_5_toggled(toggled_on):
	slotbar.emit(0, toggled_on)


func _on_slot_6_toggled(toggled_on):
	slotbar.emit(1, toggled_on)


func _on_slot_7_toggled(toggled_on):
	slotbar.emit(2, toggled_on)


func _on_slot_8_toggled(toggled_on):
	slotbar.emit(3, toggled_on)


func _on_slot_9_toggled(toggled_on):
	slotbar.emit(4, toggled_on)
