extends Resource

class_name Circle_Attack_Pattern

enum CircularDirection {
	CLOCKWISE,
	ANTICLOCKWISE
}

export (CircularDirection) var strafe_direction = CircularDirection.CLOCKWISE

# Primary resource for how the enemy should behave and attack
func get_pattern_movement_vector(direction_to_player: Vector2) -> Vector2:
	if strafe_direction == CircularDirection.CLOCKWISE:
		return Vector2(direction_to_player.y, -direction_to_player.x)
	else:
		return Vector2(-direction_to_player.y, direction_to_player.x)
