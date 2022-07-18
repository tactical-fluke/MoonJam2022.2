extends Control

export (Array, String) var lines = []
export (float) var time_per_line_finish = 3
export (float) var time_per_line_show = 5

var current_string_index = 0

var time_per_character: float = 0
var currently_shown_string = ""
var current_character = 0

var is_line_finished = false

signal line_finished

func _ready():
	hide()
	
func start_dialogue():
	show()
	$NextLineTimer.start(time_per_line_show)
	calculate_time_per_character()
	$NextCharacterTimer.start(time_per_character)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if is_line_finished:
			_on_NextLineTimer_timeout()
		else:
			finish_line()
	
func calculate_time_per_character():
	time_per_character = time_per_line_finish / lines[current_string_index].length()

func _on_NextLineTimer_timeout():
	emit_signal("line_finished")
	is_line_finished = false
	current_string_index += 1
	if current_string_index >= lines.size():
		queue_free()
		return
	
	currently_shown_string = ""
	current_character = 0
	$PanelContainer/Label.text = currently_shown_string
	calculate_time_per_character()
	$NextCharacterTimer.start(time_per_character)
	$NextLineTimer.start(time_per_line_show)

func update_dialogue_box():
	current_character += 1
	if current_character > lines[current_string_index].length():
		$NextCharacterTimer.stop()
		is_line_finished = true
		return
	currently_shown_string = lines[current_string_index].substr(0, current_character)
	$PanelContainer/Label.text = currently_shown_string
	if currently_shown_string[currently_shown_string.length() - 1] != ' ':
		$CharacterNoise.play()
	
func finish_line():
	current_character = lines[current_string_index].length() - 1
	update_dialogue_box()

func _on_NextCharacterTimer_timeout():
	update_dialogue_box()
