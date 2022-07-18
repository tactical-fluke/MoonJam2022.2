extends Control

var main_menu = "res://UI/main_menu.tscn"

func _ready():
	$Timer.start(5)


func _on_Timer_timeout():
	get_tree().change_scene(main_menu)
