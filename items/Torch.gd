extends Node2D

onready var player = get_node("/root/root/Player")

var pc_glyph = preload("res://Assets/Textures/pc.png")
var ps_glyph = preload("res://Assets/Textures/playstation.png")
var xb_glyph = preload("res://Assets/Textures/xbox.png")

var in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$PickupIcon.hide()
	player.connect('controller_signal', self ,'_set_glyph')
	pass # Replace with function body.

func _process(delta):
	if in_range == true:
		if Input.is_action_pressed("use"):
			player.toggle_torch(1)
			queue_free()
		
# Called when another body enters this items area
func _on_Area2D2_body_entered(body):
	if body.is_in_group("Player"):
		$PickupIcon.show()
		in_range = true

func _on_Area2D2_body_exited(body):
	if body.is_in_group("Player"):
		$PickupIcon.hide()
		in_range = false
	
func _set_glyph(data):
	if data == 'kb':
		$PickupIcon.set_texture(pc_glyph)
	if data == 'xb':
		$PickupIcon.set_texture(xb_glyph)
	if data == 'ps':
		$PickupIcon.set_texture(ps_glyph)
