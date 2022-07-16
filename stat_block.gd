extends Resource

class_name stat_block

export (int) var max_health = 20
export (int) var max_speed = 150

export (float) var damage_multiplier = 1
export (float) var fire_cooldown_modifer = 1

export (float) var acceleration = 20

export (Resource) var fire_type = linear_fire_type.new()
