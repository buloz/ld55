class_name MultiProjectile extends Node2D

@export var count:int

@export var spreadAngle:float
@export var projectileScene:PackedScene

var direction
var target
var team

# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile = projectileScene.instantiate()
	projectile.initialize(global_position, target, team)
	for i in count:
		var newProjectile = projectile.duplicate()
		newProjectile.direction = Vector2.from_angle(projectile.direction.angle() + -spreadAngle/2 + (spreadAngle/count)*i)
		add_child(newProjectile)
		await get_tree().create_timer(0.02).timeout

func initialize(senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):
	#var projectile : Projectile = projectileScene.instantiate()
	team = playerTeam
	
	global_position = senderPosition
	
	target = targetPosition
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()

	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
