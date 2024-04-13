extends TextureButton

@export var key:InputEventKey

# Called when the node enters the scene tree for the first time.
func _ready():
	shortcut = Shortcut.new()
	shortcut.events = [key]
