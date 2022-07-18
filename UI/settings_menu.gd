extends Control

const db_min = -50
const db_max = 10

const slider_min = 0
const slider_max = 100

func _ready():
	var master_volume = translate_decibel_value_to_slider_value(AudioServer.get_bus_volume_db(0))
	var music_volume = translate_decibel_value_to_slider_value(AudioServer.get_bus_volume_db(1))
	var effects_volume = translate_decibel_value_to_slider_value(AudioServer.get_bus_volume_db(2))
	$VBoxContainer/MasterVolume/HSplitContainer/HSlider.value = master_volume
	$VBoxContainer/MusicVolume/HSplitContainer/HSlider.value = music_volume
	$VBoxContainer/EffectsVolume/HSplitContainer/HSlider.value = effects_volume
	_on_master_volume_changed(master_volume)
	_on_music_voume_changed(music_volume)
	_on_effects_volume_changed(effects_volume)

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

func translate_slider_value_to_decibel(slider_value):
	return db_min + ((db_max - db_min) * (slider_value / slider_max))
	
func translate_decibel_value_to_slider_value(decibel_value):
	var decibel_range = db_max - db_min
	var adjusted_db_value = (decibel_value - db_min) / decibel_range
	return slider_min + ((slider_max - slider_min) * adjusted_db_value)


func _on_BackButton_pressed():
	queue_free()
