extends Area2D

signal area_entered_by_player

var triggered = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") && !triggered:
		emit_signal("area_entered_by_player")
		triggered = false
