class_name Projectile extends Area2D

@export var attack: AttackComponent
@export var speed: float

@export var isPiercing: bool
@export var piercingEntities: int = 0

@export var lifeSpan: float = 1.0

var direction

func _ready():
	await get_tree().create_timer(lifeSpan).timeout
	queue_free()

func _process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
		
		if not isPiercing:
			piercingEntities -= 1
			if piercingEntities < 0:
				queue_free()
