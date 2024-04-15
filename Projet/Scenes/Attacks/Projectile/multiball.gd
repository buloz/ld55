class_name MultiBall extends MultiProjectile


func initialize(_senderPosition: Vector2, targetPosition: Vector2, playerTeam: bool):
	super.initialize(Vector2.ZERO, targetPosition, playerTeam)
	set_as_top_level(false)
