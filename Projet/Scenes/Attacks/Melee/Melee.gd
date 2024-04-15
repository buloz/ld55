class_name Melee extends Node2D

@export var attackRange:float
@export var attack:AttackComponent

var playerTeam:bool

var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	var space_state = get_world_2d().direct_space_state
	var query:PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	var shape = CircleShape2D.new()
	shape.radius = attackRange
	query.shape = shape
	query.collision_mask = 0b10 if playerTeam else 0b01
	
	#var debug = CollisionShape2D.new()
	#debug.shape = shape
	#debug.debug_color = Color.CRIMSON
	#debug.debug_color.a = 0.5
	#debug.position = direction*attackRange
	#get_parent().add_child(debug)
	
	query.transform = Transform2D(direction.angle(), global_position + direction*attackRange)
	var collided = space_state.intersect_shape(query)
	for entry in collided:
		if !entry.is_empty() and entry.collider is HitboxComponent and entry.collider.healthComponent:
			entry.collider.damage(attack)
	
	get_tree().create_timer(1.0).timeout.connect(queue_free)

	
func initialize(_senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	playerTeam = _playerTeam
	direction = _senderPosition.direction_to(_targetPosition)
	$AttackAnimation.position = direction*attackRange


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(_delta):
