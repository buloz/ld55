class_name Blast extends Area2D

@export var targetRadius:float
@export var offsetRadius:float
@export var center:Vector3
@export var travelTime:float
@export var attack:AttackComponent

@onready var blastShape = $CollisionShape2D.shape

func _ready():
	if blastShape is CircleShape2D:
		blastShape.radius = offsetRadius

	await get_tree().create_timer(travelTime).timeout
	queue_free()

func _process(delta):
	if blastShape is CircleShape2D:
		blastShape.set_radius(blastShape.radius + delta/travelTime * (targetRadius - offsetRadius))

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
