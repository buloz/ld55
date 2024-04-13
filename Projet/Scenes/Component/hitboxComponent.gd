class_name HitboxComponent extends Area2D

@export var healthComponent: HealthComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(attack: AttackComponent):
	if healthComponent:
		healthComponent.damage(attack)
