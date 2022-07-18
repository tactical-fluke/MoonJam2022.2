extends Area2D

signal area_entered_by_player

var triggered = false

var end_scene = "res://UI/end_cutscene.tscn"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") && !triggered:
		get_tree().change_scene(end_scene)
