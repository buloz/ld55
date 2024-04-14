extends Node


@export var walkingSpeed: float = 5.0
var walkingFactor: float = 0.0
var walkingSign: float = 1.0


@export var orientationSpeed: float = 5.0
var xOrientationFactor: float = 0.0




@export var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $AnimationState.walking:
		walkingFactor += walkingSpeed * delta * walkingSign
		if walkingFactor >= 1.0:
			walkingFactor = 1.0 - (walkingFactor - 1.0)
			walkingSign = -1.0
			
		elif walkingFactor <= -1.0:
			walkingFactor = -1.0 - (walkingFactor + 1.0)
			walkingSign = 1.0
		
	else:
		walkingFactor -= walkingSpeed * delta * sign(walkingFactor)
		if is_equal_approx(walkingFactor, 0.0):
			walkingFactor = 0.0
	
	
	if $AnimationState.orientation == 1:
		xOrientationFactor += orientationSpeed * delta
		if xOrientationFactor >= 1.0:
			xOrientationFactor = 1.0
			
	elif $AnimationState.orientation == -1:
		xOrientationFactor -= orientationSpeed * delta
		if xOrientationFactor <= -1.0:
			xOrientationFactor = -1.0
	else:
		xOrientationFactor -= orientationSpeed * delta * sign(xOrientationFactor)
		if is_equal_approx(xOrientationFactor, 0.0):
			xOrientationFactor = 0.0
	
	sprite.material.set_shader_parameter("walkingAlpha", walkingFactor)
	sprite.material.set_shader_parameter("xOrientation", xOrientationFactor)

