extends Control

export (PackedScene) var start_scene
export (PackedScene) var settings_menu

func _ready():
	$PlayButton.self_modulate.a = 0
	$SettingsButton.self_modulate.a = 0

func _on_PlayButton_pressed():
	get_tree().change_scene_to(start_scene)

func _on_PlayButton_mouse_entered():
	$PlayButton.self_modulate.a = 0.3
	$MouseNoise.play()

func _on_PlayButton_mouse_exited():
	$PlayButton.self_modulate.a = 0

func _on_SettingsButton_pressed():
	add_child(settings_menu.instance())

func _on_SettingsButton_mouse_entered():
	$SettingsButton.self_modulate.a = 0.3
	$MouseNoise.play()

func _on_SettingsButton_mouse_exited():
	$SettingsButton.self_modulate.a = 0


func _on_QuitButton_mouse_entered():
	$MouseNoise.play()


func _on_QuitButton_pressed():
	get_tree().quit()
