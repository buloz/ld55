class_name MultiProjectile extends "../NoAreaSpell.gd"

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
	#var projectile = projectileScene.instantiate()
	
	#projectile.is_top_level = topLevel
	
	#if topLevel:
		#projectile.initialize(global_position, targetPosition, playerTeam)
	#else:
		#projectile.initialize(Vector2.ZERO, targetPosition, playerTeam)
		#
	#projectile.damage = damage
	
	var projectileCollisionMask = 0b10 if playerTeam else 0b01
	
	for i in count:
		var newProjectile = projectileScene.instantiate()
		
		newProjectile.collision_mask = projectileCollisionMask
		newProjectile.damage = damage
		
		newProjectile.get_node("AttackAnimation").animationIndex = animationIndex
		newProjectile.scale = animationScale
		newProjectile.get_node("CollisionShape2D").shape.radius = collisionRadius
		#newProjectile.piercingEntities = piercingEntities
		
		var newAngle = direction.angle() + -spreadAngle/2 + (spreadAngle/count)*i
		newProjectile.direction = Vector2.from_angle(newAngle)
		newProjectile.rotation = newAngle
		
		if topLevel:
			newProjectile.position = global_position
			get_node("/root/Global").currentMainScene.add_child(newProjectile)
		else:
			get_parent().add_child(newProjectile)
		
		await get_tree().create_timer(time_between_projectile).timeout
		
	#get_tree().create_timer(projectile.lifeSpan).timeout.connect(queue_free)

func initialize(senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	playerTeam = _playerTeam
	
	if topLevel:
		global_position = senderPosition
	
	targetPosition = _targetPosition
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()
	
	set_as_top_level(topLevel)
