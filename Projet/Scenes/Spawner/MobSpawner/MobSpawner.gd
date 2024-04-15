class_name MobSpawner extends Node2D

#max ennemies instanciated at full difficulty
const MAX_ENNEMIES = 150

@export var mobScene: PackedScene

#minimum frame delay between 2 waves of spawn
@export var minSpawnFrameDelay:int

#maximum frame delay between 2 waves of spawn
@export var maxSpawnFrameDelay:int

#minimum spawn distance 1.0 = viewport borders
@export var minSpawnDistance:float

#maximum spawn distance 1.0 = viewport borders
@export var maxSpawnDistance:float

var _isSpawning:bool = false

var _enabled:bool = false

var _frameAwait:int = 2

#MAX_ENNEMIES factor (100% at LifeTime.time_left = 0)
var _difficulty:float = 0.0

signal toggleSpawn(bool)

@onready var player = get_parent().get_tree().get_first_node_in_group("player")

func _ready():
	#emit toggleSpawn to enable/disable spawner
	toggleSpawn.connect(_switchSpawn)
	_enabled = true

func spawnMob(count: int):
	
	for i in count:
		var newMob: Mob = mobScene.instantiate()
		
		var spawnPosition: Vector2 = get_random_position()
		
		newMob.position = spawnPosition
		
		add_child(newMob)

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(minSpawnDistance,maxSpawnDistance) * 5
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)

func _process(delta):
	if Engine.get_process_frames() % _frameAwait != 0:
		return
	elif _enabled:
		#difficulty is at 100% after 3mn of lifetime
		_difficulty = (1 - $LifeTime.time_left/$LifeTime.wait_time)
		if _isSpawning:
			if(get_child_count() >= MAX_ENNEMIES * _difficulty):
				_stop_spawning()
				return
			spawnMob(4)
			_frameAwait = randi_range(minSpawnFrameDelay, maxSpawnFrameDelay)
		elif get_child_count() < MAX_ENNEMIES * _difficulty:
			_resume_spawning()

func _stop_spawning():
	_isSpawning = false

func _resume_spawning():
	_isSpawning = true

func _switchSpawn(value:bool):
	_enabled = value
