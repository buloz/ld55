class_name Ball extends Area2D

@export var attack: AttackComponent
@export var speed: float

@export var lifeSpan: float = 10.0

@export var max_distance: float = 2000.0

var direction

#Default shapers
const shape = preload("res://Scenes/Attacks/Projectile/Circle.tres")

func _ready():
	await get_tree().create_timer(lifeSpan).timeout
	queue_free()
	
func initialize(senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):
	collision_mask = 0b10 if playerTeam else 0b01
	
	$CollisionShape2D.shape = shape
	
	position = Vector2.ZERO
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()

func _physics_process(delta):
	if(position.distance_to(Vector2.ZERO) < max_distance):
		position += direction * speed * delta

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
