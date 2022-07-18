extends Control

export (Array, Texture) var slides
export (float) var time_per_slide
export (PackedScene) var scene_to_load_on_finish

signal cutscene_finished

var current_slide = 0

func _ready():
	$TextureRect.texture = slides[0]
	#$Timer.start(time_per_slide)
	$Dialogue.connect("line_finished", self, "progress_to_next_slide")
	$Dialogue.start_dialogue()

func progress_to_next_slide():
	current_slide += 1
	if current_slide >= slides.size():
		on_cutscene_finished()
		return
	
	$TextureRect.texture = slides[current_slide]
	$Timer.start(time_per_slide)

func _on_Timer_timeout():
	progress_to_next_slide()
	
func on_cutscene_finished():
	emit_signal("cutscene_finished")
	if scene_to_load_on_finish != null:
		get_tree().change_scene_to(scene_to_load_on_finish)
