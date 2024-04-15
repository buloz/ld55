extends Node

@export var hitBoxComponent: HitboxComponent

signal healthUpdated

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if hitBoxComponent.has_overlapping_areas():
		for body in hitBoxComponent.get_overlapping_areas():
			if body.get_parent().has_node("AttackComponent"):
				var attackComponent: AttackComponent = body.get_parent().get_node("AttackComponent")
				if not attackComponent.on_cooldown:
					hitBoxComponent.damage(attackComponent)
					healthUpdated.emit(hitBoxComponent.healthComponent.currentHealth)
					attackComponent.setOnCooldown()
