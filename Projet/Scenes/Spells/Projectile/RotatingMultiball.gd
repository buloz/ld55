class_name Conjure extends "../NoAreaSpell.gd"

const count: int = 14
const collisionRadius: float = 60
const revolutionTime: float = 2

const spreadAngle: float = 6.283

@export var projectileScene: PackedScene
const timeBetweenProjectile: float = 0.05
#@export var piercingEntities: int = 0

@export var animationIndex: int = 5
@export var animationScale: Vector2 = Vector2(0.9, 0.9)


var playerTeam: bool

func initialize(_senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	playerTeam = _playerTeam
	
	set_as_top_level(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile = projectileScene.instantiate()

	projectile.initialize(Vector2.ZERO, Vector2.ZERO, playerTeam)
	projectile.damage = damage
	
	for i in count:
		var newProjectile = projectile.duplicate()
		newProjectile.get_node("AttackAnimation").animationIndex = animationIndex
		newProjectile.scale = animationScale
		newProjectile.get_node("CollisionShape2D").shape.radius = collisionRadius
		#newProjectile.piercingEntities = piercingEntities
		
		var newAngle = projectile.direction.angle() + -spreadAngle/2 + (spreadAngle/count)*i
		newProjectile.direction = Vector2.from_angle(newAngle)
		newProjectile.rotation = newAngle + PI/2
		
		add_child(newProjectile)
		
		await get_tree().create_timer(timeBetweenProjectile).timeout
		
	get_tree().create_timer(projectile.lifeSpan).timeout.connect(queue_free)

func _process(delta):
	rotation += TAU*delta/revolutionTime
