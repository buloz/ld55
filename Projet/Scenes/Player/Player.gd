class_name PlayerClass extends CharacterBody2D

@export var maxSpeed: float = 700.0
@export var acceleration: float = 6000.0
@export var friction: float = 4000.0

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")

var actualTutoStep:int = 0

signal tutoStep(text:String)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Score
var score : int
signal scored(points : int)

func gatherMaterial(materialType: int, quantity: int):
	if actualTutoStep <= 1:
		nextTutoStep()
	$Inventory.addMaterial(materialType, quantity)
	$gather.play()

func _ready():
	$SummonSpawner.spawnTargetNode = get_parent()
	#$Inventory.storedMaterials[0] = 999
	#$Inventory.storedMaterials[1] = 999
	#$Inventory.storedMaterials[2] = 999
	#$Inventory.storedMaterials[3] = 999
	#$Inventory.storedMaterials[4] = 999
	get_node("/root/Global").Player = self
	scored.connect(implementScore)
	
func implementScore(value : int):
	score += value
	

func die():
	print("PLAYER DEAD")

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
	
	if Input.is_action_just_pressed("test"):
		#var newInstance = testAttackScene.instantiate()
		#newInstance.initialize(position, get_global_mouse_position(), true)
		#add_child(newInstance)
		pass

		#
	#velocity.x = direction.x * speed if direction.x else move_toward(velocity.x, 0, speed)
	#velocity.y = direction.y * speed if direction.y else move_toward(velocity.y, 0, speed)
	#
	move_and_slide()
	
	#Update global
	get_node("/root/Global").playerPosition = position

func _unhandled_input(event):
	if event.is_action_pressed("primary_action"):
		var summon = $Inventory.try_craft()
		if summon:
			$SummonSpawner.spawnSummon(get_global_mouse_position(), summon)
		if actualTutoStep >= 2 and actualTutoStep < 5:
			nextTutoStep()
	if event.is_action_pressed("test"):
		var spell = load("res://Scenes/Attacks/Haunted/Conjure.tscn").instantiate()
		spell.initialize(global_position, get_global_mouse_position(), true)
		add_child(spell)

func nextTutoStep():
	actualTutoStep += 1
	match actualTutoStep:
		0:
			tutoStep.emit("Gather materials by walking over it.")
		1:
			tutoStep.emit("Gather materials by walking over it.")
		2:
			tutoStep.emit("Summon your first creature by combining materials. (hint : golems loves rocks and herbs)")
		3:
			tutoStep.emit("There are plenty of tasty recipes in nature. Try yours !")
		4: 
			tutoStep.emit("")
