extends Resource

class_name linear_fire_type

## Start of the firing system. Handles linear projectiles, which ones fired carry
## on in the same direction that they were fired from
## The interface of this should be noted, as it will be reused by the Player
## type for firing

export (int) var num_projectiles
export (float, 0, 360) var maximum_angle
export (float) var projectile_speed_modifier
export (PackedScene) var projectile_type
export (float) var dist_to_spawn_away = 20

export var cooldown = 0.2; #INTERFACE TYPE

# Called when firing begins
# Should be considered an interface call, and should be implemented on other types
# of firing patterns
func begin_fire(median_dir: Vector2, owner, world_owner, damage_modifer: float):
	var angle_per_shot = maximum_angle / num_projectiles
	var angle = -maximum_angle / 2
	
	if angle == 0:
		fire(median_dir.normalized(), owner, world_owner, damage_modifer)
		return
	
	while angle < maximum_angle / 2:
		var velocity = median_dir.rotated(deg2rad(angle))
		fire(velocity, owner, world_owner, damage_modifer)
		angle += angle_per_shot

# instantiates the projectile
func fire(velocity, owner, world_owner, damage_modifier: float):
	var projectile = projectile_type.instance()
	projectile.transform = owner.transform.translated(velocity.normalized() * dist_to_spawn_away)
	projectile.rotate_sprite(velocity.angle())
	world_owner.add_child(projectile)
	projectile.set_velocity(velocity * projectile_speed_modifier)
	projectile.set_owner(owner)
	projectile.damage *= damage_modifier
