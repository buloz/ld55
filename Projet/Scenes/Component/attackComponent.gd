class_name AttackComponent extends Node

@export var attack_damage:float
@export var attack_cooldown:float
@export var knockback:float

var on_cooldown: bool = false


func setOnCooldown():
	if attack_cooldown > 0:
		on_cooldown = true
		get_tree().create_timer(attack_cooldown).timeout.connect(func(): on_cooldown = false)
