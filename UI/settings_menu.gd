extends Control

func _ready():
	_on_master_volume_changed(100)
	_on_music_voume_changed(100)
	_on_effects_volume_changed(100)

func _on_master_volume_changed(value):
	$VBoxContainer/MasterVolume/HSplitContainer/Label.text = "%d" % value
	AudioServer.set_bus_volume_db(0, translate_slider_value_to_decibel(value))
	$EffectPlayer.play()

func _on_music_voume_changed(value):
	$VBoxContainer/MusicVolume/HSplitContainer/Label.text = "%d" % value
	AudioServer.set_bus_volume_db(1, translate_slider_value_to_decibel(value))

func _on_effects_volume_changed(value):
	$VBoxContainer/EffectsVolume/HSplitContainer/Label.text = "%d" % value
	AudioServer.set_bus_volume_db(2, translate_slider_value_to_decibel(value))
	$EffectPlayer.play()

func translate_slider_value_to_decibel(value):
	var db_min = -50
	var db_max = 10
	
	return db_min + ((db_max - db_min) * (value / 100))


func _on_BackButton_pressed():
	queue_free()
