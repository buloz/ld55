class_name Summon extends "res://Scenes/Entity/Entity.gd"

var isMovingTowardPlayer: bool = false
var confortableRangeToPlayer: Vector2 = Vector2(1000, 500)


var idleNoise: FastNoiseLite = FastNoiseLite.new()

#Tempo to smooth movements
var currentDirection: Vector2 = Vector2.ZERO

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")
@onready var sprite := $ShaderAnimation/Sprite2D

func _init():
	idleNoise.seed = randi()
	
	idleNoise.frequency = 0.001
	idleNoise.fractal_octaves = 1
	idleNoise.fractal_lacunarity = 1.4
	
	playerTeam = true
	chaseTarget = true

const SPRITE_PROPERTIES := [
	[Vector2(0.75, 0.75), Vector2(0, -290)], #golem
	[Vector2(0.5, 0.5), Vector2(0, -307)], #goule
	[Vector2(0.4, 0.4), Vector2(0, -312)], #squelette
	[Vector2(0.5, 0.5), Vector2(0, -369)], #spectre
]

func loadSummonSprite(summonType: int, summonSubtype: int):
	sprite.frame = summonType * 3 + summonSubtype
	sprite.scale = SPRITE_PROPERTIES[summonType][0]
	sprite.offset = SPRITE_PROPERTIES[summonType][1]


const SPELLS := [
	preload("res://Scenes/Attacks/Golem/Tumble.tscn"),
	preload("res://Scenes/Attacks/Golem/Shockwave.tscn"),
	preload("res://Scenes/Attacks/Golem/Crumbs.tscn"),
	preload("res://Scenes/Attacks/Ghoul/Spit.tscn"),
	preload("res://Scenes/Attacks/Ghoul/Leap.tscn"),
	preload("res://Scenes/Attacks/Ghoul/GhoulMelee.tscn"),
	preload("res://Scenes/Attacks/Skeleton/Bomb.tscn"),
	preload("res://Scenes/Attacks/Skeleton/Multishot.tscn"),
	preload("res://Scenes/Attacks/Skeleton/SkeletonMelee.tscn"),
	preload("res://Scenes/Attacks/Haunted/Conjure.tscn"),
	preload("res://Scenes/Attacks/Haunted/Thunder.tscn"),
	preload("res://Scenes/Attacks/Haunted/Howl.tscn"),
]

var summonInfo : SummonInfo
func initializeFromInfo(_summonInfo: SummonInfo):
	summonInfo = _summonInfo
	
	$CasterComponent.spellScene = SPELLS[summonInfo.spellType]
	
	$HealthComponent.MaxHealth = summonInfo.health
	
	$AttackComponent.attack_damage = summonInfo.damage
	$AttackComponent.attack_cooldown = summonInfo.cooldown
	
	$CasterComponent.distanceToCast = summonInfo.attackRange
	
	self.confortDistance = confortDistance
	
func _ready():
	loadSummonSprite(summonInfo.type, summonInfo.subtype)
	$ShaderAnimation.setUnique()

func die():
	$HealthComponent.queue_free()
	$NearestEnnemyFinder.queue_free()
	$DamageReceiver.queue_free()
	$HitBoxComponent.queue_free()
	$AttackComponent.queue_free()
	$CasterComponent.queue_free()
	set_physics_process(false)
	
	var t := create_tween()
	t.set_trans(Tween.TRANS_BOUNCE)
	t.tween_property(sprite, "position:x", -30, 0.05)
	t.tween_property(sprite, "position:x", 25, 0.075)
	t.tween_property(sprite, "position:x", -20, 0.075)
	t.tween_property(sprite, "position:x", 15, 0.075)
	t.tween_property(sprite, "position:x", 0, 0.15)
	
	var t2 := create_tween()
	t2.set_trans(Tween.TRANS_CUBIC)
	t2.set_ease(Tween.EASE_OUT)
	t2.tween_property(sprite, "scale:x", 0.0, 1.5)
	t2.parallel().tween_property(sprite, "scale:y", 0.0, 0.7)
	t2.tween_callback(queue_free)

func updateMovement(direction, updateSpeed, delta):
	
	#Temps en secondes pour atteindre la nouvelle direction...
	currentDirection = currentDirection.lerp(direction, 1.5 * delta)
	
	position += currentDirection * updateSpeed * delta
	
	#TODO: pondérer walking ici
	#animationState.walking 
	animationState.orientation = currentDirection.x

func _physics_process(delta):
	
	var isChasing: bool = false
	
	if hasTarget:
		distanceToTarget = position.distance_to(targetPosition)
	
		if chaseTarget and hasTarget:
			if distanceToTarget > confortDistance:
				isChasing = true
				var direction: Vector2 = position.direction_to(targetPosition)
				updateMovement(direction, speed, delta)
				animationState.walking = true
	
	if not isChasing:
		
		var distanceToPlayer: float = position.distance_to(get_node("/root/Global").playerPosition)
		var directionToPlayer: Vector2 = position.direction_to(get_node("/root/Global").playerPosition)
		
		var minimalDistanceToPlayer: float = confortableRangeToPlayer.y if isMovingTowardPlayer else confortableRangeToPlayer.x
		
		if distanceToPlayer > minimalDistanceToPlayer:
			updateMovement(directionToPlayer, speed, delta)
			isMovingTowardPlayer = true
			animationState.walking = true
			
		else:
			isMovingTowardPlayer = false
			
			#IDLE STATE HERE
			var angleFactor: float = idleNoise.get_noise_2d(position.x + (Time.get_ticks_msec() / 1000.0), position.y - (Time.get_ticks_msec() / 1000.0)) * 1.5
			
			updateMovement((directionToPlayer * (distanceToPlayer / confortableRangeToPlayer.x) + Vector2.from_angle(2 * PI * angleFactor)).normalized(), speed * 0.2, delta)
			
			#TODO: pondérer le walking
			animationState.walking = false

