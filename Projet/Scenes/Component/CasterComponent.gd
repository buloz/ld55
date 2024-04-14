extends Node

#Distance for the entity to start a spell cast
@export_range(0.0, 1000.0) var distanceToCast: float

@export var spellScene: PackedScene
@export var attackComponent: AttackComponent


func _ready():
	attackComponent.cooldown.connect(activate)
	activate(attackComponent.on_cooldown)

func activate(b : bool):
	set_process(!b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_parent().hasTarget and get_parent().distanceToTarget < distanceToCast:
		print("Distance to target: ", get_parent().distanceToTarget)
		
		#Create and add new spell instance
		var newSpell = spellScene.instantiate()
		newSpell.initialize(get_parent().global_position, get_parent().targetPosition, get_parent().playerTeam)
		newSpell.get_node("AttackComponent").attack_damage = attackComponent.attack_damage
		
		add_child(newSpell)
		
		attackComponent.setOnCooldown()
