extends Node2D

export (PackedScene) var effect_scene

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		var effect = effect_scene.instance()
		body.add_child(effect)
