class_name Charge extends "../Spell.gd"

var playerTeam:bool
var isCharging:bool
var positionA
var positionB
var distance:float = 900.0
var speed:float = 3.0
var weight:float

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	if get_parent() is CasterComponent:
		isCharging = true;

func initialize(senderPosition: Vector2, targetPosition: Vector2, _playerTeam: bool):
	collision_mask = 0b10 if _playerTeam else 0b01
	
	positionA = senderPosition
	positionB = positionA + (senderPosition.direction_to(targetPosition) * distance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isCharging:
		weight += delta*speed
		get_parent().get_parent().position = positionA.lerp(positionB, weight)
	if(weight >= 1):
		queue_free()

func _on_area_entered(area):
	if area is HitboxComponent:
		area.get_parent().takeDamage(damage)
