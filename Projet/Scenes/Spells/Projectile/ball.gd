class_name Ball extends "../Spell.gd"

@export var speed: float

@export var lifeSpan: float = 10.0

@export var max_distance: float = 2000.0
var traveled_distance: float = 0.0

@export var is_top_level: bool = false

var initialPosition: Vector2
var direction

func _ready():
	await get_tree().create_timer(lifeSpan).timeout
	queue_free()
	
func initialize(senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):
	collision_mask = 0b10 if playerTeam else 0b01
	
	$AttackAnimation.animationIndex = 2
	
	position = senderPosition
	initialPosition = position
	
	direction = senderPosition.direction_to(targetPosition)
	rotation = direction.angle()
	
	set_as_top_level(is_top_level)

func _physics_process(delta):
	if(traveled_distance < max_distance):
		
		traveled_distance += speed * delta
		if traveled_distance > max_distance:
			traveled_distance = max_distance

		var alpha: float = (traveled_distance / max_distance) / 2.0
		
		alpha = 1.0 - pow(alpha * 2.0 - 1.0, 2.0)
		
		position = initialPosition + (direction * max_distance) * alpha

func _on_area_entered(area):
	if area is HitboxComponent:
		area.get_parent().takeDamage(damage)
