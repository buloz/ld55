class_name Projectile extends Area2D

@export var attack: AttackComponent
@export var speed: float

@export var isPiercing: bool
@export var piercingEntities: int = 0

@export var lifeSpan: float = 1.0

@export var is_top_level: bool

var direction

#Default shapers
const arrowShape = preload("res://Scenes/Attacks/Projectile/Arrow.tres")
const circleShape = preload("res://Scenes/Attacks/Projectile/Circle.tres")

func _ready():
	await get_tree().create_timer(lifeSpan).timeout
	queue_free()
	
func initialize(senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):	
	collision_mask = 0b10 if playerTeam else 0b01
	
	$CollisionShape2D.shape = circleShape
	
	
	global_position = senderPosition
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()
	#$CollisionShape2D.rotation = rotation
	set_as_top_level(is_top_level)
	

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
		
		if not isPiercing:
			piercingEntities -= 1
			if piercingEntities < 0:
				queue_free()
