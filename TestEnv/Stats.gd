extends Node

class_name Stats

var health : int = 0 setget set_health , get_health

func _init(health_value = 0):
	health = health_value

func get_health() -> int:
	return health

func set_health(value : int) -> void:
	health = value
