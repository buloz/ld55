class_name HealthComponent extends Node

@export var MaxHealth:float

var currentHealth

func _ready():
	currentHealth = MaxHealth

func damage(attack: AttackComponent):
			
	currentHealth -= attack.attack_damage
	print("took ", attack.attack_damage, " damage")
	
	attack.setOnCooldown()
	
	if currentHealth <= 0:
		get_parent().queue_free()

func canAcceptCollision():
	return currentHealth > 0
