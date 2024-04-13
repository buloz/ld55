class_name Mob extends "res://Scenes/Entity/Entity.gd"

func _init():
	playerTeam = false
	chaseTarget = true
	
func _physics_process(delta):
	
	if hasTarget and chaseTarget:
		distanceToTarget = position.distance_to(targetPosition)
		if distanceToTarget > foeDistance:
			var direction: Vector2 = position.direction_to(targetPosition)
			position += direction * speed * delta
