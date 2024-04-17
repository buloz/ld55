extends HBoxContainer

@onready var healthChunk = preload("res://Scenes/UserInterface/healthChunk.tscn")

var maxHp : float

func setMaxHealth(m:float):
	maxHp = m
	for i in 10:
		var child = healthChunk.instantiate()
		child.update(2)
		add_child(child)

func updateHealthPoint(currentHealthPoint:float):
	var chunks = round(currentHealthPoint/maxHp * 10)
	var state = snapped(currentHealthPoint/maxHp * 2, 1)
	var children = get_children()
	for i in chunks:
		children[i].update(state)
	for i in range(chunks, children.size()):
		children[i].update(state)
		children[i].visible = false
