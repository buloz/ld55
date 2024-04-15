class_name PlayerClass extends CharacterBody2D

@export var projectileScene: PackedScene
@export var multiProjectileScene: PackedScene
@export var ballScene: PackedScene
@export var blastScene: PackedScene
@export var strikeScene: PackedScene
@export var projectileShapeResource: Shape2D

@export var maxSpeed: float = 700.0
@export var acceleration: float = 6000.0
@export var friction: float = 4000.0

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func gatherMaterial(materialType: int, quantity: int):
	print("J'ai rammassé %d" % materialType)
	$Inventory.addMaterial(materialType, quantity)

func _ready():
	$SummonSpawner.spawnTargetNode = get_parent()
	
	get_node("/root/Global").Player = self

#TODO: faire un déplacement plus smooooooooth
func _physics_process(delta):
	
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	if direction == Vector2.ZERO:
		if velocity.length() > (friction * delta):			
			velocity -= velocity.normalized() * (friction * delta)
		
		else:
			velocity = Vector2.ZERO
			
		animationState.walking = false
		animationState.orientation = 0
		
	else:
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(maxSpeed)
		
		animationState.walking = true
		animationState.orientation = velocity.normalized().x


		#
	#velocity.x = direction.x * speed if direction.x else move_toward(velocity.x, 0, speed)
	#velocity.y = direction.y * speed if direction.y else move_toward(velocity.y, 0, speed)
	#
	move_and_slide()
	
	#Update global
	get_node("/root/Global").playerPosition = position
	
func _process(_delta):
	if Input.is_action_pressed("primary_action"):
		#$SummonSpawner.spawnSummon(get_global_mouse_position(), ballScene)
		var newProjectile = projectileScene.instantiate()
		
		newProjectile.initialize(position, get_global_mouse_position(), true)
		
		add_child( newProjectile )
	
	if Input.is_action_just_pressed("test"):
		$SummonSpawner.spawnSummon(get_global_mouse_position(), multiProjectileScene)
		
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			$SummonSpawner.spawnSummon(get_global_mouse_position(), blastScene)
		if event.pressed and event.keycode == KEY_R:
			$SummonSpawner.spawnSummon(get_global_mouse_position(), strikeScene)
