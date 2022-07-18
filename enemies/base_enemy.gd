extends KinematicBody2D

export (NodePath) var area_trigger
onready var _area_trigger = get_node(area_trigger)

enum EnemyState {
	IDLE,
	ATTACK,
	FLEE,
	DEAD,
	POOF
}

export (float) var preferred_attack_distance = 0;
export (Resource) var stat_block = stat_block.new()
export (float) var player_damage_knockback = 200 # how much force with which this should be pushed back if it deals melee damage to the player
export (float) var damage_knockback = 40 # how much force this should be pushed back with if it takes damage
export (float) var additional_fire_cooldown_modifier = 1

export (Resource) var attack_pattern = Circle_Attack_Pattern.new()

var velocity = Vector2.ZERO

var state = EnemyState.IDLE

var can_fire = true

var health = health_resource.new()

onready var player = get_node("/root/root/Player")

var dead_direction = "left"

var death_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if _area_trigger != null:
		_area_trigger.connect("area_entered_by_player", self, "_on_area_trigger_entered_by_player")
	health.init_health(stat_block.max_health)
	health.connect("died", self, "handle_death")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		EnemyState.IDLE:
			pass
		EnemyState.ATTACK:
			attack_process(delta)
		EnemyState.FLEE:
			flee_process(delta)
		_:
			pass
	
	
	handle_animation()

# Area trigger to put the enemy into fight mode
func _on_area_trigger_entered_by_player():
	if state != EnemyState.DEAD && state != EnemyState.POOF:
		state = EnemyState.ATTACK

# Per frame attack process
func attack_process(delta):
	if player == null:
		pass
	
	var dist_to_player = transform.get_origin().distance_to(player.transform.get_origin())
	if dist_to_player > preferred_attack_distance:
		move_to_player(delta)
	else:
		var dir_to_player = get_direction_to_player()
		velocity = velocity.move_toward(attack_pattern.get_pattern_movement_vector(), stat_block.acceleration)
		move_and_slide(velocity)
		if can_fire && stat_block.fire_type != null:
			stat_block.fire_type.begin_fire(dir_to_player, self, self.owner, stat_block.damage_modifier)
			can_fire = false
			$FireTimer.start(stat_block.fire_type.cooldown * stat_block.fire_cooldown_modifer * additional_fire_cooldown_modifier)
		

# move toward the player (and deal damage if a collision with the player occurs)
func move_to_player(delta):
	var direction_to_player = get_direction_to_player()
	velocity = velocity.move_toward(direction_to_player * stat_block.max_speed, stat_block.acceleration)
	var collision = move_and_collide(velocity * delta)
	if collision != null && collision.collider.is_in_group("Player"):
		collision.collider.take_damage(ceil(stat_block.damage_modifier))
		velocity = -direction_to_player * player_damage_knockback

func flee_process(delta):
	pass

func get_direction_to_player() -> Vector2:
	return (player.transform.get_origin() - transform.get_origin()).normalized()

func _on_FireTimer_timeout():
	can_fire = true
	$FireTimer.stop()
	
func handle_projectile(projectile, damage):

	match state:
		EnemyState.POOF:
			$CollisionShape2D.disabled = true
			pass
		_:
			projectile.queue_free()
			health.take_damage(damage)
	
func get_side_of_player() -> String:
	var left = get_direction_to_player().x < 0
	return "left" if left else "right"

func handle_death():
	state = EnemyState.DEAD
	dead_direction = get_side_of_player()
	
func handle_animation():
	var anim_suffix = get_side_of_player()
	match state:
		EnemyState.DEAD:
			$Sprite.play("death_%s" % dead_direction)
			yield(get_tree().create_timer(1.0), "timeout")
			state = EnemyState.POOF
		EnemyState.POOF:
			$Sprite.play("poof")
			print($Sprite.animation)
		_: #TODO
			$Sprite.play("idle_%s" % anim_suffix)

func _on_Sprite_animation_finished():
	print("pppoof")
	if ($Sprite.animation == "poof"):
		hide()
		queue_free()
