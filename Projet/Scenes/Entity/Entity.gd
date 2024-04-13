class_name Entity extends Node2D

#TODO: ces attributs là devrait être stocké dans un component de l'entité qui contient ses propriété (range, speed, etc)
#A quel distance l'ennemi doit allez de la cible
@export var foeDistance: float = 0.0
@export var speed: float = 300.0

var chaseTarget: bool
var hasTarget: bool
var targetPosition: Vector2

var playerTeam: bool

	
func _physics_process(delta):
	
	if chaseTarget and hasTarget:
		if position.distance_to(targetPosition) > foeDistance:
			var direction: Vector2 = position.direction_to(targetPosition)
			position += direction * speed * delta
