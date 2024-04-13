class_name Projectile extends Area2D

@export var attack: AttackComponent
@export var speed:float

var direction

func _process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
