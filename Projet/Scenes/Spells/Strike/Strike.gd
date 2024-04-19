class_name Strike extends "../Spell.gd"

@export var delay:float

@onready var finder:Node2D = get_node("NearestEnemyFinder")

var hasTarget:bool = false
var distanceToTarget: float

var targetPosition
var playerTeam
var strike:bool = false


func initialize(senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	self.playerTeam = _playerTeam
	
	collision_mask = 0b10 if _playerTeam else 0b01
		
	position = senderPosition
	set_as_top_level(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$NearestEnemyFinder.setRadius(1200)
	
	$AnimatedSprite2D.frame = 7

	await get_tree().create_timer(delay).timeout
	
	$AnimationPlayer.play("thunder")
	$AudioStreamPlayer2D.play()
	
	for area in get_overlapping_areas():
		if area is HitboxComponent and hasTarget:
			area.get_parent().takeDamage(damage)
			
	get_tree().create_timer(1.0).timeout.connect(queue_free)

func _physics_process(_delta):
	if hasTarget and !strike:
		position = targetPosition
		strike = true
