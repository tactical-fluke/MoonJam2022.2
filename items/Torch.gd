extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called when another body enters this items area
func _on_Area2D_body_entered(body):
	print("xd")
	if body.is_in_group("Player"):
		body.toggle_torch(1)
		queue_free()
