class_name MultiBall extends MultiProjectile


func initialize(senderPosition: Vector2, _targetPosition: Vector2, _playerTeam: bool):
	super.initialize(Vector2.ZERO, _targetPosition, _playerTeam)
	set_as_top_level(false)
