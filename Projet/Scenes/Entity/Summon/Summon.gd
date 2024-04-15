class_name Summon extends "res://Scenes/Entity/Entity.gd"

var isMovingTowardPlayer: bool = false
var confortableRangeToPlayer: Vector2 = Vector2(1000, 500)


var idleNoise: FastNoiseLite = FastNoiseLite.new()

#Tempo to smooth movements
var currentDirection: Vector2 = Vector2.ZERO

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")

func _init():
	idleNoise.seed = randi()
	
	idleNoise.frequency = 0.001
	idleNoise.fractal_octaves = 1
	idleNoise.fractal_lacunarity = 1.4
	
	playerTeam = true
	chaseTarget = true

func loadRandomSummon():
	loadSummonType(randi_range(0, 3), randi_range(0, 2))
	
func loadSpellType(spellType:int):
	match spellType:
		0:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Golem/Tumble.tscn")
		1:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Golem/Shockwave.tscn")
		2:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Golem/Crumbs.tscn")
		3:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Ghoul/Spit.tscn")
		4:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Ghoul/Leap.tscn")
		5:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Ghoul/GhoulMelee.tscn")
		6:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Skeleton/Bomb.tscn")
		7:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Skeleton/Multishot.tscn")
		8:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Skeleton/SkeletonMelee.tscn")
		9:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Haunted/Conjure.tscn")
		10:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Haunted/Thunder.tscn")
		11:
			$CasterComponent.spellScene = preload("res://Scenes/Attacks/Haunted/Howl.tscn")

func loadSummonType(summonType: int, summonSubtype: int):
	
	
	match summonType:
		0:
			if summonSubtype == 1:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Golem_1.png")
			elif summonSubtype == 2:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Golem_2.png")
			else:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Golem.png")
				
			$Sprite2D.scale = Vector2(0.75, 0.75)
			$Sprite2D.offset.y = -290

		1:
			if summonSubtype == 1:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Goule_1.png")
			elif summonSubtype == 2:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Goule_2.png")
			else:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Goule.png")
				
			$Sprite2D.scale = Vector2(0.5, 0.5)
			$Sprite2D.offset.y = -307

		2:
			if summonSubtype == 1:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Squelette_1.png")
			elif summonSubtype == 2:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Squelette_2.png")
			else:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Squelette.png")
			
			$Sprite2D.scale = Vector2(0.4, 0.4)
			$Sprite2D.offset.y = -312

		3:
			if summonSubtype == 1:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Spectre_1.png")
			elif summonSubtype == 2:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Spectre_2.png")
			else:
				$Sprite2D.texture = preload("res://Ressources/sprites/Summon/Spectre.png")
				
			$Sprite2D.scale = Vector2(0.5, 0.5)
			$Sprite2D.offset.y = -369


func initializeFromInfo(summonInfo: SummonInfo):
	
	loadSummonType(summonInfo.type, summonInfo.subtype)
	loadSpellType(summonInfo.spellType)
	
	$HealthComponent.MaxHealth = summonInfo.health
	
	$AttackComponent.attack_damage = summonInfo.damage
	$AttackComponent.attack_cooldown = summonInfo.cooldown
	
	$CasterComponent.distanceToCast = summonInfo.attackRange
	
	self.confortDistance = summonInfo.confortDistance
	
func _ready():
	$ShaderAnimation.setUnique()
	$NearestEnnemyFinder.setRadius(1200)

func updateMovement(direction, updateSpeed, delta):
	
	#Temps en secondes pour atteindre la nouvelle direction...
	currentDirection = currentDirection.lerp(direction, 1.5 * delta)
	
	position += currentDirection * updateSpeed * delta
	
	#TODO: pondérer walking ici
	#animationState.walking 
	animationState.orientation = currentDirection.x

func _physics_process(delta):
	
	if Engine.get_physics_frames() % 2 != 0:
		return
	
	var isChasing: bool = false
	if hasTarget:
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

