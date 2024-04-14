class_name Mob extends "res://Scenes/Entity/Entity.gd"

@onready var animationState: AnimationState = $ShaderAnimation.get_node("AnimationState")



func _init():
	playerTeam = false
	chaseTarget = true
	
	
func loadRandomMob():
	var choosenSpriteIndex: int = randi_range(0, 4)
	match choosenSpriteIndex:
		0:
			$Sprite2D.texture = preload("res://Ressources/sprites/Mobs/Biche.png")
			$Sprite2D.scale = Vector2(0.5, 0.5)
			$Sprite2D.position.y = -120
		1:
			$Sprite2D.texture = preload("res://Ressources/sprites/Mobs/Grenouille.png")
			$Sprite2D.scale = Vector2(0.15, 0.15)
			$Sprite2D.position.y = -100
		2:
			$Sprite2D.texture = preload("res://Ressources/sprites/Mobs/Chat.png")
			$Sprite2D.scale = Vector2(0.2, 0.2)
			$Sprite2D.position.y = -20
		3:
			$Sprite2D.texture = preload("res://Ressources/sprites/Mobs/Lapin.png")
			$Sprite2D.scale = Vector2(0.28, 0.28)
			$Sprite2D.position.y = -17
		4:
			$Sprite2D.texture = preload("res://Ressources/sprites/Mobs/Vach.png")
			$Sprite2D.scale = Vector2(0.5, 0.5)
			$Sprite2D.position.y = -120
	
func _ready():
	loadRandomMob()
	$ShaderAnimation.setUnique()
	animationState.walking = true

func _physics_process(delta):
	
	if hasTarget and chaseTarget:
		distanceToTarget = position.distance_to(targetPosition)
		if distanceToTarget > foeDistance:
			var direction: Vector2 = position.direction_to(targetPosition)
			
			animationState.orientation = direction.normalized().x
			
			position += direction * speed * delta
