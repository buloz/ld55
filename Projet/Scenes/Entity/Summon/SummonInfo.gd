class_name SummonInfo extends Node

#GOLEM, GOULE, SQUELETTE, SPECTRE
var type: int
var spellType: int

var health: float

var damage: float

#As seconds
var cooldown: float

#Radius (distance)
var attackRange: float

#Radius (distance)
var confortDistance: float


func _init(type: int, spellType: int, health: float, damage: float, cooldown: float, attackRange: float, confortDistance: float):
	self.type = type
	self.spellType = spellType
	self.health = health
	self.damage = damage
	self.cooldown = cooldown
	self.attackRange = attackRange
	self.confortDistance = confortDistance
