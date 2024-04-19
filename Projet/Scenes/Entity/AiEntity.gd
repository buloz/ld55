class_name AiEntity extends "Entity.gd"

#TODO: ces attributs là devrait être stocké dans un component de l'entité qui contient ses propriété (range, speed, etc)
#A quel distance l'ennemi doit allez de la cible
@export var confortDistance: float = 0.0
@export var speed: float = 300.0

#Chasing logic
var chaseTarget: bool
var hasTarget: bool
var targetPosition: Vector2
var distanceToTarget: float

var playerTeam: bool

func _ready():
	super()
