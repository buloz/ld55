extends TextureButton

@export var key:InputEventKey
@export var additionalTexture:Texture2D

var eventIndex:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AdditionalTexture.texture = additionalTexture
	shortcut = Shortcut.new()
	shortcut.events = [key]

func set_quantity(v: int):
	$Label.text = str(v)

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			eventIndex = event.index
			get_viewport().set_input_as_handled()
		if event.index == eventIndex:
			if !event.pressed:
				button_pressed = !button_pressed
			get_viewport().set_input_as_handled()
