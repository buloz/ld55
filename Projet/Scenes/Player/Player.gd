class_name PlayerClass extends CharacterBody2D

@export var projectileScene: PackedScene
@export var blastScene: PackedScene
@export var strikeScene: PackedScene
@export var projectileShapeResource: Shape2D

@export var speed = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func gatherMaterial(materialType: int, quantity: int):
	print("J'ai rammassé %d" % materialType)
	$Inventory.addMaterial(materialType, quantity)

func _ready():
	get_node("/root/Global").Player = self

#TODO: faire un déplacement plus smooooooooth
func _physics_process(_delta):
	
	

	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	velocity.x = direction.x * speed if direction.x else move_toward(velocity.x, 0, speed)
	velocity.y = direction.y * speed if direction.y else move_toward(velocity.y, 0, speed)
	
	move_and_slide()
	
	#Update global
	get_node("/root/Global").playerPosition = position
	
func _process(_delta):
	if Input.is_action_pressed("primary_action"):
		var projectile : Projectile = projectileScene.instantiate()
		
		projectile.initialize(position, get_global_mouse_position(), true)

		add_child(projectile)
	
	if Input.is_action_just_pressed("test"):
		$SummonSpawner.spawnSummon(get_global_mouse_position())
		
		
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			var blast : Blast = blastScene.instantiate()
			blast.initialize(global_position, get_global_mouse_position(), true)
			add_child(blast)
		if event.pressed and event.keycode == KEY_R:
			var strike : Strike = strikeScene.instantiate()
			strike.initialize(global_position, get_global_mouse_position(), true)
			add_child(strike)
