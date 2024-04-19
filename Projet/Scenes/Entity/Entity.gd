extends Node2D

@export var MaxHealth:float
var currentHealth: float

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")

func _ready():
	currentHealth = MaxHealth

func die():
	pass

func takeDamage(damage: float):
	currentHealth -= damage
	animationState.damageTaken = 1.0
	
	if currentHealth <= 0:
		die()

func canAcceptCollision():
	return currentHealth > 0
