extends Node

@export var sprite: Node2D

func _process(delta):
	if $EnvironementAnimationState.touched >= 0.0:
		$EnvironementAnimationState.touched -= delta
		
		if $EnvironementAnimationState.touched < 0.0:
			$EnvironementAnimationState.touched = 0.0
		
	sprite.material.set_shader_parameter("touched", $EnvironementAnimationState.touched)


func environementTouchedByArea(area):
	if area.get_parent() is Summon and not area.get_parent().animationState.walking:
		$EnvironementAnimationState.touched = 0.5
	else:
		$EnvironementAnimationState.touched = 1.0
	

func environementTouchedByBody(body):
	$EnvironementAnimationState.touched = body.velocity.length() / 700.0
