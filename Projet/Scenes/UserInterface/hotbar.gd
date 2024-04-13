class_name Hotbar extends HBoxContainer

signal slotbar(slot_name)

func _on_slot_0_toggled(toggled_on):
	slotbar.emit(0, toggled_on)


func _on_slot_1_toggled(toggled_on):
	slotbar.emit(1, toggled_on)


func _on_slot_2_toggled(toggled_on):
	slotbar.emit(2, toggled_on)


func _on_slot_3_toggled(toggled_on):
	slotbar.emit(3, toggled_on)


func _on_slot_4_toggled(toggled_on):
	slotbar.emit(4, toggled_on)
