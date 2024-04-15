class_name Mob extends "res://Scenes/Entity/Entity.gd"

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")
@onready var sprite := $ShaderAnimation/Sprite2D


func _init():
	playerTeam = false
	chaseTarget = true

const SPRITE_PROPERTIES := [
	[Vector2(0.5, 0.5), Vector2(0, -325)], #biche
	[Vector2(0.15, 0.15), Vector2(0, -348)], #tortue
	[Vector2(0.2, 0.2), Vector2(0, -380)], #chat
	[Vector2(0.28, 0.28), Vector2(0, -276)], #lapin
	[Vector2(0.5, 0.5), Vector2(-60, -362)], #vach
]

func loadRandomMob():
	var index : int = randi() % sprite.sprite_frames.get_frame_count("default")
	sprite.frame = index
	sprite.scale = SPRITE_PROPERTIES[index][0]
	sprite.offset = SPRITE_PROPERTIES[index][1]

func _ready():
	loadRandomMob()
	$ShaderAnimation.setUnique()
	animationState.walking = true

func die():
	$AttackComponent.queue_free()
	$HealthComponent.queue_free()
	$NearestEnnemyFinder.queue_free()
	$HitBoxComponent.queue_free()
	set_physics_process(false)
	
	var t := create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(sprite, "scale:y", 0.0, 0.5)
	t.tween_callback(queue_free)

func _physics_process(delta):
	if hasTarget and chaseTarget:
		distanceToTarget = position.distance_to(targetPosition)
		if distanceToTarget > confortDistance:
			var direction: Vector2 = position.direction_to(targetPosition)
			
			animationState.orientation = direction.normalized().x
			
			position += direction * speed * delta
