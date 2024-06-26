class_name Blast extends "../Spell.gd"

@export var targetRadius:float
@export var offsetRadius:float
@export var center:Vector3
@export var travelTime:float
@export var attack:AttackComponent

@onready var blastShape = $CollisionShape2D.shape

func initialize(_senderPosition: Vector2, _targetPosition: Vector2, playerTeam: bool):
	collision_mask = 0b10 if playerTeam else 0b01

func _ready():
	$AnimationPlayer.play("shockWave")
	$AudioStreamPlayer2D.play()
	
	if blastShape is CircleShape2D:
		blastShape.radius = offsetRadius

	await get_tree().create_timer(travelTime).timeout
	set_physics_process(false)
	collision_mask = 0
	
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta):
	if blastShape is CircleShape2D:
		blastShape.set_radius(blastShape.radius + delta/travelTime * (targetRadius - offsetRadius))

func _on_area_entered(area):
	if area is HitboxComponent:
		area.get_parent().takeDamage(damage)
