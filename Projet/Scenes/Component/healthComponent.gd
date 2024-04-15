class_name HealthComponent extends Node

@export var MaxHealth:float

var currentHealth: float

func _ready():
	currentHealth = MaxHealth

func damage(attack: AttackComponent):
	currentHealth -= attack.attack_damage
	
	#print("took %f damages" % attack.attack_damage)

	get_parent().animationState.damageTaken = 1.0
	
	if currentHealth <= 0:
		get_parent().die()

		

func canAcceptCollision():
	return currentHealth > 0
