extends KinematicBody2D

export (float) var movement_speed = 40
export (float) var friction = 20
export (float) var acceleration = 20


var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
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
		
	var effective_acceleration =  acceleration / movement_keys_pressed
	
	if Input.is_action_pressed("movement_up"):
		velocity.y -= effective_acceleration
	if Input.is_action_pressed("movement_down"):
		velocity.y += effective_acceleration
	if Input.is_action_pressed("movement_left"):
		velocity.x -= effective_acceleration
	if Input.is_action_pressed("movement_right"):
		velocity.x += effective_acceleration
		
	velocity = velocity.clamped(movement_speed)


func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	get_movement_input()
	move_and_slide(velocity)
