extends Node

func _ready():
	$ScreenFilter/ScreenFilterRect.start(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("secondary_action"):
		$MainScene.get_node("MobSpawner").spawnMob(20)
