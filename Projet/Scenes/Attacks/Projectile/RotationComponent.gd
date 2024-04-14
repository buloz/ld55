extends Node

@export var revolution_time:float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var parent = get_parent()
	if parent is MultiProjectile:
		parent.rotation += TAU*delta/revolution_time
