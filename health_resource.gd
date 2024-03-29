extends Resource

class_name health_resource

var health: int = 1 setget set_health

signal died

func init_health(start_health):
	health = start_health

func set_health(new_health):
	health = new_health
	if health < 0:
		emit_signal("died")

func take_damage(damage):
	set_health(health - damage)
		
func heal(healing, maximum):
	set_health(health + healing)
	set_health(clamp(health, 0, maximum))
