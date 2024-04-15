extends TextureButton

@export var key:InputEventKey
@export var additionalTexture:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AdditionalTexture.texture = additionalTexture
	shortcut = Shortcut.new()
	shortcut.events = [key]
