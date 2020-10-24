extends Node

class_name KinematicStats

var detect_radius : float = 0.0 setget set_detect_radius , get_detect_radius

func _init(radius_value = 0):
	detect_radius = radius_value

func set_detect_radius(value : float) -> void:
	detect_radius = value

func get_detect_radius() -> float:
	return detect_radius
