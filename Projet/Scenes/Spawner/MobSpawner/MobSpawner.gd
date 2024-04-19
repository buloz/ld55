class_name MobSpawner extends Node2D

#max ennemies instanciated at full difficulty
const MAX_ENNEMIES = 400

@export var mobScene: PackedScene

#minimum frame delay between 2 waves of spawn
@export var minSpawnFrameDelay:float = 2

#maximum frame delay between 2 waves of spawn
@export var maxSpawnFrameDelay:float = 4

#minimum spawn distance 1.0 = viewport borders
@export var minSpawnDistance:float

#maximum spawn distance 1.0 = viewport borders
@export var maxSpawnDistance:float


@export var minMobSpeed: float = 150
@export var maxMobSpeed: float = 600
@onready var speedOffset: float = maxMobSpeed - minMobSpeed
@export var mobMaxDificultyHealth: float = 300

var directionAngle: float


var noise: FastNoiseLite = FastNoiseLite.new()

var _enabled:bool = false

#MAX_ENNEMIES factor (100% at LifeTime.time_left = 0)
var _difficulty:float = 0.0

signal toggleSpawn(bool)

@onready var player = get_parent().get_tree().get_first_node_in_group("player")

func _ready():
	
	noise.seed = randi()
	
	noise.frequency = 0.05
	noise.fractal_octaves = 1
	noise.fractal_lacunarity = 1.4
	
	directionAngle = noise.get_noise_1d(Time.get_ticks_msec() / 1000.0)
	
	#emit toggleSpawn to enable/disable spawner
	toggleSpawn.connect(_switchSpawn)
	_enabled = true

func spawnMob(count: int):
	
	
	"""
	A scale en fonction de la difficulté
	Speed
	
	"""
	
	directionAngle += noise.get_noise_1d(Time.get_ticks_msec() / 1000.0) * 4.0
	#print(directionAngle, " ", Vector2.from_angle(directionAngle))
	
	var difficutyScaledSpeed: float = minMobSpeed + _difficulty * speedOffset
	
	
	for i in count:
		var newMob: Mob = mobScene.instantiate()
		
		#var spawnPosition: Vector2 = get_random_position()
		
		var newnAngle = directionAngle + randf_range(-1.3, 1.3)
		#print(newnAngle, " ", Vector2.from_angle(newnAngle))
		
		newMob.position = player.global_position + Vector2.from_angle(newnAngle) * randf_range(minSpawnDistance, maxSpawnDistance)
		newMob.speed = difficutyScaledSpeed
		newMob.speedAcceleration = 100 + 200 * _difficulty
		newMob.MaxHealth += mobMaxDificultyHealth * _difficulty
		
		add_child(newMob)

#func get_random_position():
	#var vpr = get_viewport_rect().size * randf_range(minSpawnDistance,maxSpawnDistance) * 5
	#var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	#var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	#var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	#var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	#var pos_side = ["up","down","right","left"].pick_random()
	#var spawn_pos1 = Vector2.ZERO
	#var spawn_pos2 = Vector2.ZERO
	#
	#match pos_side:
		#"up":
			#spawn_pos1 = top_left
			#spawn_pos2 = top_right
		#"down":
			#spawn_pos1 = bottom_left
			#spawn_pos2 = bottom_right
		#"right":
			#spawn_pos1 = top_right
			#spawn_pos2 = bottom_right
		#"left":
			#spawn_pos1 = top_left
			#spawn_pos2 = bottom_left
	#
	#var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	#var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	#return Vector2(x_spawn,y_spawn)

func _process(_delta):
	if Engine.get_process_frames() % 10 != 0:
		return
		
	elif _enabled and $SpawnDelay.is_stopped():
		
		#difficulty is at 100% after 3mn of lifetime
		_difficulty = (1 - $LifeTime.time_left/$LifeTime.wait_time)
		
		$SpawnDelay.start(randf_range(minSpawnFrameDelay - (1.5 * _difficulty), maxSpawnFrameDelay - (3 * _difficulty)))
		if(get_child_count() <= MAX_ENNEMIES * _difficulty):
			spawnMob(randi_range(3, 6))

func _switchSpawn(value:bool):
	_enabled = value
