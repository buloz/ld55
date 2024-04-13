extends Node

#Distance for the entity to start a spell cast
@export_range(0.0, 1000.0) var distanceToCast: float

@export var spellScene: PackedScene
@export var attackComponent: AttackComponent



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not attackComponent.on_cooldown:
		
		if get_parent().hasTarget and get_parent().distanceToTarget < distanceToCast:
			
			print("Distance to target: ", get_parent().distanceToTarget)
			
			#Create and add new spell instance
			var newSpell = spellScene.instantiate()
			
			newSpell.initialize(get_parent().global_position, get_parent().targetPosition)
			
			newSpell.get_node("AttackComponent").attack_damage = attackComponent.attack_damage
			add_child(newSpell)
			
			attackComponent.setOnCooldown()
			