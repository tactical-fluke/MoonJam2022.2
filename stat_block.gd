extends Resource

class_name stat_block

signal max_health_changed

export (int) var max_health = 20
export (int) var current_health = 20

export (int) var max_speed = 150

export (float) var damage_multiplier = 1
export (float) var fire_cooldown_modifer = 1

export (float) var acceleration = 20

export (Resource) var fire_type = linear_fire_type.new()

func set_max_health(new_health):
	max_health = new_health
	emit_signal("max_health_changed")
	emit_changed()
