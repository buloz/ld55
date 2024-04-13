class_name HitboxComponent extends Area2D

@export var healthComponent: HealthComponent

func damage(attack: AttackComponent):
	if healthComponent:
		healthComponent.damage(attack)
