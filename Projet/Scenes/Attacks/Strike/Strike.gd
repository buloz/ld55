class_name Strike extends Area2D

@export var delay:float
@export var attack:AttackComponent

@onready var finder:Node2D = get_node("NearestEnemyFinder")

var hasTarget:bool = false

var targetPosition
var playerTeam
var strike:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_mask = 0b01
	if playerTeam:
		collision_mask <<= 1
	await get_tree().create_timer(delay).timeout
	for area in get_overlapping_areas():
		if area is HitboxComponent and area.healthComponent and hasTarget:
			area.damage(attack)
	queue_free()

func _physics_process(_delta):
	if hasTarget and !strike:
		position = targetPosition
		strike = true
