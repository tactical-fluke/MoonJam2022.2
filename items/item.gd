extends Node2D

export (Resource) var stat_block

export (String) var hover_description
export (String) var extended_description

onready var player = get_node("/root/root/Player")

var pc_glyph = preload("res://Assets/Textures/pc.png")
var ps_glyph = preload("res://Assets/Textures/playstation.png")
var xb_glyph = preload("res://Assets/Textures/xbox.png")

var in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/Label.text = hover_description
	$PanelContainer.hide()
	$PickupIcon.hide()
	player.connect('controller_signal', self ,'_set_glyph')
	
func _process(delta):
	if in_range == true:
		if Input.is_action_pressed("use"):
			interacted()
		
func interacted():
	var player_stat_block = player.stat_block
	player_stat_block.max_health += stat_block.max_health
	player_stat_block.max_speed += stat_block.max_speed
	player_stat_block.acceleration += stat_block.acceleration
	player_stat_block.damage_modifier += stat_block.damage_modifier
	player_stat_block.fire_cooldown_modifer += stat_block.fire_cooldown_modifer
	queue_free()
	

func _on_Area2D2_body_entered(body):
	if body.is_in_group("Player"):
		$PanelContainer.show()
		in_range = true


func _on_Area2D2_body_exited(body):
	if body.is_in_group("Player"):
		$PanelContainer.hide()
		in_range = false
		
func _set_glyph(data):
	if data == 'kb':
		$PickupIcon.set_texture(pc_glyph)
	if data == 'xb':
		$PickupIcon.set_texture(xb_glyph)
	if data == 'ps':
		$PickupIcon.set_texture(ps_glyph)
