class_name Projectile extends Area2D

@export var attack: AttackComponent
@export var speed: float

@export var isPiercing: bool
@export var piercingEntities: int = 0

@export var lifeSpan: float = 1.0

var direction

#Default shapers
const arrowShape = preload("res://Scenes/Attacks/Projectile/Arrow.tres")

func _ready():
	await get_tree().create_timer(lifeSpan).timeout
	queue_free()
	
func initialize(senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):
	#var projectile : Projectile = projectileScene.instantiate()
	
	collision_mask = 0b10 if playerTeam else 0b01
	
	$CollisionShape2D.shape = arrowShape
	
	global_position = senderPosition
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()

	set_as_top_level(true)
	

func _process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
		
		if not isPiercing:
			piercingEntities -= 1
			if piercingEntities < 0:
				queue_free()

 
