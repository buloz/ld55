class_name SummonInfo extends Node

#GOLEM, GOULE, SQUELETTE, SPECTRE
var type: int
var subtype: int
var spellType: int

var health: float

var damage: float

#As seconds
var cooldown: float

#Radius (distance)
var attackRange: float

#Radius (distance)
var confortDistance: float

var speed: float

func _init(_type: int, _subtype: int, _spellType: int, _health: float, _damage: float, _cooldown: float, _attackRange: float, _confortDistance: float, _speed: float):
	self.type = _type
	self.subtype = _subtype
	self.spellType = _spellType
	self.health = _health
	self.damage = _damage
	self.cooldown = _cooldown
	self.attackRange = _attackRange
	self.confortDistance = _confortDistance
	self.speed = _speed
