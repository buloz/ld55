class_name Entity extends Node2D

#TODO: ces attributs là devrait être stocké dans un component de l'entité qui contient ses propriété (range, speed, etc)
#A quel distance l'ennemi doit allez de la cible
@export var foeDistance: float = 0.0
@export var speed: float = 300.0

var target: Vector2

	
func _physics_process(delta):
	if position.distance_to(target) > foeDistance:
		var direction: Vector2 = position.direction_to(target)
		position += direction * speed * delta
