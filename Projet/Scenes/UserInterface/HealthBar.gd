extends HBoxContainer

@onready var healthChunk = preload("res://Scenes/UserInterface/healthChunk.tscn")

var maxHp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHealth(max:float):
	maxHp = max
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
