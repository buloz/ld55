class_name MultiProjectile extends Node2D

@export var count:int
@export var collisionRadius:float = 30


@export var spreadAngle:float
@export var projectileScene:PackedScene
@export var time_between_projectile:float
#@export var piercingEntities: int = 0

@export var animationIndex: int
@export var animationScale: Vector2 = Vector2.ONE

@export var topLevel: bool = false


var direction
var targetPosition
var playerTeam

# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile = projectileScene.instantiate()
	
	projectile.is_top_level = topLevel
	
	if topLevel:
		projectile.initialize(global_position, targetPosition, playerTeam)
	else:
		projectile.initialize(Vector2.ZERO, targetPosition, playerTeam)
		
	projectile.get_node("AttackComponent").attack_damage = $AttackComponent.attack_damage
	for i in count:
		var newProjectile = projectile.duplicate()
		newProjectile.get_node("AttackAnimation").animationIndex = animationIndex
		newProjectile.scale = animationScale
		newProjectile.get_node("CollisionShape2D").shape.radius = collisionRadius
		#newProjectile.piercingEntities = piercingEntities
		
		var newAngle = projectile.direction.angle() + -spreadAngle/2 + (spreadAngle/count)*i
		newProjectile.direction = Vector2.from_angle(newAngle)
		newProjectile.rotation = newAngle
		
		add_child(newProjectile)
		
		await get_tree().create_timer(time_between_projectile).timeout
		
	get_tree().create_timer(projectile.lifeSpan).timeout.connect(queue_free)

func initialize(senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	playerTeam = _playerTeam
	
	if topLevel:
		global_position = senderPosition
	
	targetPosition = _targetPosition
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()
	
	set_as_top_level(true)
