class_name PlayerClass extends CharacterBody2D

@export var maxSpeed: float = 700.0
@export var acceleration: float = 6000.0
@export var friction: float = 4000.0

@onready var animationState: AnimationState = $PlayerSpriteRenderer/ShaderAnimation/AnimationState
#@onready var animationState: AnimationState = $ShaderAnimation/AnimationState

@export var testProjectile: PackedScene

var actualTutoStep:int = 0
#[timeAlive, entity killed]
var score:Array = [0.0,0]

signal tutoStep(text:String)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Score
signal scored(points : int)

func gatherMaterial(materialType: int, quantity: int):
	if actualTutoStep <= 1:
		nextTutoStep()
	$Inventory.addMaterial(materialType, quantity)
	$gather.play()

func _ready():
	$DamageReceiver.healthUpdated.connect(damage)
	$SummonSpawner.spawnTargetNode = get_parent()
	$Inventory.storedMaterials[0] = 999
	$Inventory.storedMaterials[1] = 999
	$Inventory.storedMaterials[2] = 999
	$Inventory.storedMaterials[3] = 999
	$Inventory.storedMaterials[4] = 999
	get_node("/root/Global").Player = self
	scored.connect(incrementScore)
	
func incrementScore(value : int):
	score[1] += value
	

func damage(v: int):
	if v == 0:
		$die.play()
	else:
		$damage.play()

func die():
	
	get_node("/root/Global").playerDead = true
	
	$SummonSpawner.queue_free()
	$HealthComponent.queue_free()
	$HitBoxComponent.queue_free()
	$CollisionShape2D2.queue_free()
	$DamageReceiver.queue_free()
	
	set_physics_process(false)
	set_process_input(false)
	
	animationState.walking = false
	animationState.orientation = 0.0
	
	
	$die.play()
	$PlayerSpriteRenderer/ShaderAnimation.get_node("AnimationPlayer").play("death")
	get_node("../../MainScene").lose.emit(score)


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

func _process(delta):
	score[0] += delta

func _unhandled_input(event):
	if event.is_action_pressed("primary_action") and not get_node("/root/Global").playerDead:
		var summon = $Inventory.try_craft()
		if summon:
			$SummonSpawner.spawnSummon(get_global_mouse_position(), summon)
		if actualTutoStep >= 2 and actualTutoStep < 4:
			nextTutoStep()

func _input(event):
	if event is InputEventKey and event.is_action_pressed("test"):
		var newProjectile = testProjectile.instantiate()
		newProjectile.initialize(position, get_global_mouse_position(), true)
		add_child(newProjectile)

const tutorialSteps : PackedStringArray = [
	"Gather materials by walking over it.",
	"Gather materials by walking over it.",
	"Summon your first creature by combining materials. (hint : golems loves rocks and herbs)",
	"There are plenty of tasty recipes in nature.\nTry yours !",
	"",
]

func nextTutoStep():
	actualTutoStep += 1
	tutoStep.emit(tutorialSteps[actualTutoStep])
