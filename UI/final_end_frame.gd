extends Control

export (PackedScene) var credits_scene

func _ready():
	$Timer.start(5)

func _on_Timer_timeout():
	get_tree().change_scene_to(credits_scene)
