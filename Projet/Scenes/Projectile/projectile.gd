class_name Projectile extends Area2D

@export var attack: AttackComponent
@export var speed:float
@export var piercingEntities:int
@export var isPiercing:bool
@export var lifeSpan:float

var direction

func _ready():
	await get_tree().create_timer(10.0).timeout
	queue_free()

func _process(delta):
	global_position += direction * speed * delta
	

func _on_area_entered(area):
	if area is HitboxComponent and area.healthComponent:
		area.damage(attack)
		piercingEntities -= 1
		if(piercingEntities <= 0):
			queue_free()
