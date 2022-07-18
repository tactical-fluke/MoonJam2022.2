extends KinematicBody2D

var velocity = Vector2.ZERO

var projectile_owner: Node

export (int) var damage = 4 ## INTERFACE TYPE

## Projectile type
## This is what gets actually fired by the player, and interacts with walls/enemies/players etc.

# Called when the node enters the scene tree for the first time.
func _ready():
	print("linear projectile created")
	if randf() < 0.5:
		$AttackNoise1.play()
	else:
		$AttackNoise2.play()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		handle_collision(collision)

# sets the velocity for this vector.
func set_velocity(new_velocity: Vector2):
	velocity = new_velocity

# sets which entity spawned this projectile. That entity is ignored during collisions
func set_owner(new_owner):
	projectile_owner = new_owner

# handles any collisions that occur
func handle_collision(collision: KinematicCollision2D):
	if collision.collider_id != projectile_owner.get_instance_id() && collision.collider.is_in_group("projectile handler"):
		collision.collider.handle_projectile(self, damage)
	if collision.collider is TileMap: #make sure it disappears when it hits the boundary of the map
		queue_free()
		
func rotate_sprite(angle):
	$Sprite.rotate(angle)
