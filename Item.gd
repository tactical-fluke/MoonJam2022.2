extends Node2D

export (Resource) var stat_block


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called when another body enters this items area
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		var player_stat_block = body.stat_block
		player_stat_block.max_health += stat_block.max_health
		player_stat_block.max_speed += stat_block.max_speed
		player_stat_block.acceleration += stat_block.acceleration
		player_stat_block.damage_multiplier += stat_block.damage_multiplier
		queue_free()
