class_name MultiProjectile extends Node2D

@export var count:int

@export var spreadAngle:float
@export var projectileScene:PackedScene
@export var time_between_projectile:float

var direction
var targetPosition
var playerTeam

# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile = projectileScene.instantiate()
	projectile.initialize(global_position, targetPosition, playerTeam)
	for i in count:
		var newProjectile = projectile.duplicate()
		newProjectile.direction = Vector2.from_angle(projectile.direction.angle() + -spreadAngle/2 + (spreadAngle/count)*i)
		add_child(newProjectile)
		await get_tree().create_timer(time_between_projectile).timeout
	await get_tree().create_timer(projectile.lifeSpan).timeout

func initialize(senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	playerTeam = _playerTeam
	
	global_position = senderPosition
	
	targetPosition = _targetPosition
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()
	
	set_as_top_level(true)
