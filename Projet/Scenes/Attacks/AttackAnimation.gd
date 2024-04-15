extends Sprite2D

@export var animationIndex: int = 0


func indexToAnimation():
	
	match animationIndex:
		0:
			$AnimationPlayer.play("fireBall")
		1:
			$AnimationPlayer.play("cailloux")
		2:
			$AnimationPlayer.play("flaque")
		3:
			$AnimationPlayer.play("melee")
		4:
			$AnimationPlayer.play("bomb")
		5:
			$AnimationPlayer.play("fire")

# Called when the node enters the scene tree for the first time.
func _ready():
	indexToAnimation()
