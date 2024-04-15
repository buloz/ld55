class_name Melee extends Node2D

@export var attackRange:float
@export var attack:AttackComponent

var playerTeam:bool

var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func initialize(_senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	playerTeam = _playerTeam
	direction = _senderPosition.direction_to(_targetPosition)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var space_state = get_world_2d().direct_space_state
	var query:PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	var shape = CircleShape2D.new()
	shape.radius = attackRange
	query.shape = shape
	query.transform = Transform2D(direction.angle(), global_position + direction*attackRange)
	var collided = space_state.intersect_shape(query)
	for entry in collided:
		if !entry.is_empty() and entry.collider is HitboxComponent and entry.collider.healthComponent:
			entry.collider.damage(attack)
	queue_free()
