extends Node

func adjust_damage_modifier(damage_modifier: float):
	if randf() > 0.75:
		return damage_modifier * 1.25
	else:
		return damage_modifier
