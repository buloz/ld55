class_name PlayerClass extends CharacterBody2D

@export var projectileScene: PackedScene
@export var blastScene: PackedScene
@export var strikeScene: PackedScene
@export var projectileShapeResource: Shape2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func gatherMaterial(materialType: int, quantity: int):
	print("J'ai rammassé %d" % materialType)
	$Inventory.addMaterial(materialType, quantity)

func _ready():
	get_node("/root/Global").Player = self

#TODO: faire un déplacement plus smooooooooth
func _physics_process(_delta):

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xDirection = Input.get_axis("move_left", "move_right")
	var yDirection = Input.get_axis("move_up", "move_down")
	
	velocity.x = xDirection * SPEED if xDirection else move_toward(velocity.x, 0, SPEED)
	velocity.y = yDirection * SPEED if yDirection else move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
	
	#Update global
	get_node("/root/Global").playerPosition = position
	
func _process(_delta):
	if Input.is_action_pressed("primary_action"):
		var projectile : Projectile = projectileScene.instantiate()
		projectile.get_node("CollisionShape2D").shape = projectileShapeResource
		var projectileDirection = global_position.direction_to(get_global_mouse_position())
		var projectileRotation = projectileDirection.angle()
		projectile.rotation = projectileRotation
		projectile.direction = projectileDirection
		projectile.global_position = global_position
		projectile.set_as_top_level(true)
		add_child(projectile)
	
	if Input.is_action_just_pressed("test"):
		$SummonSpawner.spawnSummon(get_global_mouse_position())
		
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			var blast : Blast = blastScene.instantiate()
			add_child(blast)
		if event.pressed and event.keycode == KEY_R:
			var strike : Strike = strikeScene.instantiate()
			strike.playerTeam = true
			strike.position = global_position
			strike.set_as_top_level(true)
			add_child(strike)
