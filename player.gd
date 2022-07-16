extends KinematicBody2D

export (float) var friction = 20

export (Resource) var stat_block

var velocity = Vector2.ZERO

var can_fire = true

# Gets the movement input. Modifies `velocity`
func get_movement_input():
	var movement_keys_pressed = 0
	if Input.is_action_pressed("movement_up"):
		movement_keys_pressed += 1
	if Input.is_action_pressed("movement_down"):
		movement_keys_pressed += 1
	if Input.is_action_pressed("movement_left"):
		movement_keys_pressed += 1
	if Input.is_action_pressed("movement_right"):
		movement_keys_pressed += 1
		
	var effective_acceleration = stat_block.acceleration
	if movement_keys_pressed > 0:
		stat_block.acceleration / movement_keys_pressed
	
	if Input.is_action_pressed("movement_up"):
		velocity.y -= effective_acceleration
	if Input.is_action_pressed("movement_down"):
		velocity.y += effective_acceleration
	if Input.is_action_pressed("movement_left"):
		velocity.x -= effective_acceleration
	if Input.is_action_pressed("movement_right"):
		velocity.x += effective_acceleration
		
	velocity = velocity.clamped(stat_block.max_speed)

# General per physics tick process function
func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	get_movement_input()
	move_and_slide(velocity)

# General per frame tick function
func _process(delta):
	if Input.is_action_pressed("fire"):
		fire()

# Gets the median fire direction of the wanted to fire projectile
func get_fire_direction() -> Vector2:
	var fire_dir = Vector2.ZERO
	if Input.is_action_pressed("aim_up"):
		fire_dir.y -= 1
	if Input.is_action_pressed("aim_down"):
		fire_dir.y += 1
	if Input.is_action_pressed("aim_left"):
		fire_dir.x -= 1
	if Input.is_action_pressed("aim_right"):
		fire_dir.x += 1
		
	if fire_dir.is_equal_approx(Vector2.ZERO):
		return Vector2(0, -1)
	else:
		return fire_dir.normalized()

# handles any projectiles that it does not own colliding with it
func handle_projectile(projectile):
	pass #TODO

# Fires, using whichever firetype is currently equipped
func fire():
	if !can_fire:
		return
		
	can_fire = false
	$FireTimer.start(self.stat_block.fire_type.cooldown * self.stat_block.fire_cooldown_modifer)
	var fire_direction = get_fire_direction()
	stat_block.fire_type.begin_fire(fire_direction, self, self.owner)

# signal handler for the fire timer timeout
func _on_FireTimer_timeout():
	can_fire = true
	$FireTimer.stop()