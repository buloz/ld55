class_name AttackComponent extends Node

signal cooldown(bool)

@export var attack_damage:float
@export var attack_cooldown:float
@export var knockback:float

var on_cooldown: bool = false

func _set_cooldown(b : bool):
	on_cooldown = b
	cooldown.emit(b)

func setOnCooldown():
	if attack_cooldown > 0:
		_set_cooldown(true)
		get_tree().create_timer(attack_cooldown).timeout.connect(offCooldown)

func offCooldown():
	if attack_cooldown != 0 and on_cooldown:
		_set_cooldown(true)
