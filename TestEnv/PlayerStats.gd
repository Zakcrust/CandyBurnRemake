extends Stats

class_name PlayerStats

var armour : int = 0 setget set_armour, get_armour

func _init(health_value = 0, armour_value = 0):
	._init(health_value)
	armour = armour_value

func set_armour(value :int) -> void:
	armour = value

func get_armour() -> int:
	return armour
