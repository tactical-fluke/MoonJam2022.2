extends Node2D

func restart():
	get_tree().reload_current_scene()

func _on_Player_player_died():
	restart()
