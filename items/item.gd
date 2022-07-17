extends Node2D

export (Resource) var stat_block

export (String) var hover_description
export (String) var extended_description

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/Label.text = hover_description
	$PanelContainer.hide()

# Called when another body enters this items area
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		var player_stat_block = body.stat_block
		player_stat_block.max_health += stat_block.max_health
		player_stat_block.max_speed += stat_block.max_speed
		player_stat_block.acceleration += stat_block.acceleration
		player_stat_block.damage_modifier += stat_block.damage_modifier
		player_stat_block.fire_cooldown_modifer += stat_block.fire_cooldown_modifer
		queue_free()


func _on_Area2D2_body_entered(body):
	if body.is_in_group("Player"):
		$PanelContainer.show()


func _on_Area2D2_body_exited(body):
	if body.is_in_group("Player"):
		$PanelContainer.hide()
