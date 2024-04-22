extends TextureButton

@export var key:InputEventKey
@export var additionalTexture:Texture2D

var cooldownSeconds: float = 1.0
var cooldownDelta: float = 0.0
var quantity: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AdditionalTexture.texture = additionalTexture
	shortcut = Shortcut.new()
	shortcut.events = [key]
	updateActivateState()

func _process(delta):
	
	if cooldownDelta > 0.0:
		cooldownDelta -= delta / cooldownSeconds
		if cooldownDelta <= 0.0:
			cooldownDelta = 0.0
			updateActivateState()
	
	material.set_shader_parameter("cooldown", cooldownDelta)

func setOnCooldown(cd: float):
	cooldownSeconds = cd
	cooldownDelta = 1.0
	
	material.set_shader_parameter("randomOffset", Vector2(randf(), randf()))
	
	updateActivateState()

func set_quantity(v: int):
	quantity = v
	$Label.text = str(quantity)
	updateActivateState()
	
func updateActivateState():
	if cooldownDelta > 0.0 or quantity == 0:
		disabled = true
	else:
		disabled = false
