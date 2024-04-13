class_name Summon extends "res://Scenes/Entity/Entity.gd"

var isMovingTowardPlayer: bool = false
var confortableRangeToPlayer: Vector2 = Vector2(1000, 500)


var idleNoise: FastNoiseLite = FastNoiseLite.new()


#Tempo to smooth movements
var currentDirection: Vector2 = Vector2.ZERO



func _init():
	idleNoise.seed = randi()
	
	idleNoise.frequency = 0.001
	idleNoise.fractal_octaves = 1
	idleNoise.fractal_lacunarity = 1.4
	
	playerTeam = true
	chaseTarget = true


func updateMovement(direction, updateSpeed, delta):
	
	#Temps en secondes pour atteindre la nouvelle direction...
	
	currentDirection = currentDirection.lerp(direction, 1.5 * delta)
	
	position += currentDirection * updateSpeed * delta

func _physics_process(delta):
	
	var isChasing: bool = false
	
	if hasTarget:
		distanceToTarget = position.distance_to(targetPosition)
	
		if chaseTarget and hasTarget:
			if distanceToTarget > foeDistance:
				isChasing = true
				var direction: Vector2 = position.direction_to(targetPosition)
				updateMovement(direction, speed, delta)
	
	if not isChasing:
		
		var distanceToPlayer: float = position.distance_to(get_node("/root/Global").playerPosition)
		var directionToPlayer: Vector2 = position.direction_to(get_node("/root/Global").playerPosition)
		
		var minimalDistanceToPlayer: float = confortableRangeToPlayer.y if isMovingTowardPlayer else confortableRangeToPlayer.x
		
		if distanceToPlayer > minimalDistanceToPlayer:
			updateMovement(directionToPlayer, speed, delta)
			isMovingTowardPlayer = true
		else:
			isMovingTowardPlayer = false
			
			#IDLE STATE HERE
			var angleFactor: float = idleNoise.get_noise_2d(position.x + (Time.get_ticks_msec() / 1000.0), position.y - (Time.get_ticks_msec() / 1000.0)) * 1.5
			
			updateMovement((directionToPlayer * (distanceToPlayer / confortableRangeToPlayer.x) + Vector2.from_angle(2 * PI * angleFactor)).normalized(), speed * 0.2, delta)
