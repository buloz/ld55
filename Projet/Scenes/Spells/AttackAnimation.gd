extends Sprite2D

@export var animationIndex: int = 0


func indexToAnimation():
	match animationIndex:
		0:
			$AnimationPlayer.play("fireBall")
			$fireball.play()
		1:
			$AnimationPlayer.play("cailloux")
			$fireball.play()
		2:
			$AnimationPlayer.play("flaque")
			$flaque.play()
		3:
			$AnimationPlayer.play("melee")
			$melee.play()
		4:
			$AnimationPlayer.play("bomb")
			$fireball.play()
		5:
			$AnimationPlayer.play("fire")
			$fireball.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	indexToAnimation()
