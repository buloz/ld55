extends Node2D

@export var randomStartOffset: bool = false

@export var walkingSpeed: float = 5.0
var walkingFactor: float = 0.0
var walkingSign: float = 1.0


@export var orientationSpeed: float = 5.0
var xOrientationFactor: float = 0.0

@onready var sprite = $Sprite2D

func _ready():
	sprite.material.set_shader_parameter("randomFloat", randf())
	
	if randomStartOffset:
		walkingFactor = randf_range(-1.0, 1.0)
		walkingSign = -1 if randi() % 2 else 1

#To make shader ressource unique
func setUnique():
	sprite.material.resource_local_to_scene = true
	
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
		var oldSign: float = sign(walkingFactor)
		walkingFactor -= walkingSpeed * delta * oldSign
		
		if oldSign != sign(walkingFactor) or is_equal_approx(walkingFactor, 0.0):
			walkingFactor = 0.0
	
	
	if $AnimationState.orientation > 0:
		xOrientationFactor += orientationSpeed * delta
		if xOrientationFactor >= $AnimationState.orientation:
			xOrientationFactor = $AnimationState.orientation
			
	elif $AnimationState.orientation < 0:
		xOrientationFactor -= orientationSpeed * delta
		if xOrientationFactor <= $AnimationState.orientation:
			xOrientationFactor = $AnimationState.orientation
	else:
		var oldSign: float = sign(xOrientationFactor)
		xOrientationFactor -= orientationSpeed * delta * oldSign
		
		if oldSign != sign(xOrientationFactor) or is_equal_approx(xOrientationFactor, 0.0):
			xOrientationFactor = 0.0
	
	if $AnimationState.damageTaken > 0.0:
		$AnimationState.damageTaken -= delta
		if $AnimationState.damageTaken < 0.0:
			$AnimationState.damageTaken = 0.0
			
	if $AnimationState.spawned > 0.0:
		$AnimationState.spawned -= delta * 5.0
		if $AnimationState.spawned < 0.0:
			$AnimationState.spawned = 0.0
	
	sprite.material.set_shader_parameter("walkingAlpha", walkingFactor)
	sprite.material.set_shader_parameter("xOrientation", xOrientationFactor)
	sprite.material.set_shader_parameter("damageState", $AnimationState.damageTaken)
	sprite.material.set_shader_parameter("spawnState", $AnimationState.spawned)
