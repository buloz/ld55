class_name Charge extends Area2D

@export var attack:AttackComponent

var playerTeam:bool
var isCharging:bool
var positionA
var positionB
var distance:float = 900.0
var speed:float = 3.0
var weight:float

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is CasterComponent:
		isCharging = true;

func initialize(senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):
	collision_mask = 0b10 if playerTeam else 0b01
	
	positionA = senderPosition
	positionB = positionA + (senderPosition.direction_to(targetPosition) * distance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isCharging:
		weight += delta*speed
		get_parent().get_parent().position = positionA.lerp(positionB, weight)
	if(weight >= 1):
		queue_free()

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
