extends Node2D

export (String) var hover_description
export (String) var extended_description

onready var player = get_node("/root/root/Player")

var pc_glyph = preload("res://Assets/Textures/pc.png")
var ps_glyph = preload("res://Assets/Textures/playstation.png")
var xb_glyph = preload("res://Assets/Textures/xbox.png")

var chest_closed_image = preload("res://Assets/Textures/chest_closed_texture.tres")
var chest_open_image = preload("res://Assets/Textures/chest_open_texture.tres")

var in_range = false

var stay_hidden = false

var interacted_with = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = chest_closed_image
	$PanelContainer/Label.text = hover_description
	$PanelContainer.hide()
	$PickupIcon.hide()
	player.connect('controller_signal', self ,'_set_glyph')
	
func _process(delta):
	if in_range == true:
		if Input.is_action_pressed("use"):
			interacted()
		
func interacted():
	if !interacted_with:
		interacted_with = true 
		$PunchlineTimer.start()
		$Sprite.texture = chest_open_image
		$ChestOpenNoise.play()
		$PanelContainer.hide()
		$PickupIcon.hide()
	

func _on_Area2D2_body_entered(body):
	if body.is_in_group("Player") && !stay_hidden:
		$PanelContainer.show()
		$PickupIcon.show()
		in_range = true


func _on_Area2D2_body_exited(body):
	if body.is_in_group("Player"):
		$PanelContainer.hide()
		$PickupIcon.hide()
		in_range = false
		
func _set_glyph(data):
	if data == 'kb':
		$PickupIcon.set_texture(pc_glyph)
	if data == 'xb':
		$PickupIcon.set_texture(xb_glyph)
	if data == 'ps':
		$PickupIcon.set_texture(ps_glyph)
		
func show_extended_description():
	$Control/CanvasLayer/Dialogue.lines[0] = extended_description
	$Control/CanvasLayer/Dialogue.start_dialogue()
	stay_hidden = true

func _on_PunchlineTimer_timeout():
	show_extended_description()
	$FartNoise.play()
