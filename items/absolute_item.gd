extends Node2D

export (Resource) var stat_block

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called when another body enters this items area
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		var player_stat_block = body.stat_block
		if stat_block.max_health != 0: player_stat_block.max_health = stat_block.max_health
		if stat_block.max_speed != 0: player_stat_block.max_speed = stat_block.max_speed
		if stat_block.acceleration != 0: player_stat_block.acceleration = stat_block.acceleration
		if stat_block.damage_modifier != 1: player_stat_block.damage_modifier = stat_block.damage_modifier
		if stat_block.fire_cooldown_modifier != 1: player_stat_block.fire_cooldown_modifer = stat_block.fire_cooldown_modifer
		if stat_block.fire_type != null: player_stat_block.fire_type = stat_block.fire_type
		
		queue_free()
