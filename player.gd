extends KinematicBody2D

export (float) var friction = 20

export (Resource) var stat_block

var health = health_resource.new()

var velocity = Vector2.ZERO

var can_fire = true

var torch_lit = false
var torch_timer = Timer.new()

signal controller_signal
var last_input

func _ready():
	stat_block.connect("max_health_changed", self, "handle_max_health_changed")
	health.init_health(stat_block.max_health)
	health.connect("died", self, "handle_death")
	init_torch()

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

func _input(event):
	if event is InputEventKey:
		last_input = 'kb'
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		if Input.is_joy_known(0):
			if Input.get_joy_name(0) == 'XInput Gamepad':
				last_input = 'xb'
			if Input.get_joy_name(0) == 'PS5 Controller' || Input.get_joy_name(0) == 'PS4 Controller':
				last_input = 'ps'
	emit_signal('controller_signal', last_input)
	pass

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
func handle_projectile(projectile, damage):
	projectile.queue_free()
	take_damage(damage)


func take_damage(damage):
	health.take_damage(damage)

# Fires, using whichever firetype is currently equipped
func fire():
	if !can_fire:
		return
		
	can_fire = false
	$FireTimer.start(self.stat_block.fire_type.cooldown * self.stat_block.fire_cooldown_modifer)
	var fire_direction = get_fire_direction()
	var damage_modifier = get_damage_modifer()
	stat_block.fire_type.begin_fire(fire_direction, self, self.owner, damage_modifier)

# signal handler for the fire timer timeout
func _on_FireTimer_timeout():
	can_fire = true
	$FireTimer.stop()

func handle_death():
	print("player died")

func handle_max_health_changed():
	health.set_health(stat_block.max_health)

func get_damage_modifer() -> float:
	var damage_modifier = stat_block.damage_modifier
	for child in get_children():
		if child.has_method("adjust_damage_modifier"):
			damage_modifier = child.adjust_damage_modifier(damage_modifier)
	
	return damage_modifier

func init_torch():
	toggle_torch(0)
	
func toggle_torch(state):
	if state == 1:
		torch_lit = true
		$TorchLight2D.show()
		torch_timer.connect("timeout",self,"snuff_torch")
		torch_timer.wait_time = 3
		torch_timer.one_shot = true
		add_child(torch_timer)
		torch_timer.start()		
	elif state == 0:
		torch_lit = false
		$TorchLight2D.hide()
		
func snuff_torch():
	torch_lit = false
	$TorchLight2D.hide()
	

