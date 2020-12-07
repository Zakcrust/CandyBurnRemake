extends Stats

class_name PlayerStats

var armour : int = 0 setget set_armour, get_armour
var energy : int = 0 setget set_energy, get_energy


func _init(health_value = 0, armour_value = 0, energy_value = 0):
	._init(health_value)
	armour = armour_value
	energy = energy_value

func set_armour(value :int) -> void:
	armour = value

func get_armour() -> int:
	return armour

func set_energy(value : int) -> void:
	energy = value

func get_energy() -> int:
	return energy

