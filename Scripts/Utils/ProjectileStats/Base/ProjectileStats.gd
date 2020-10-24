extends Node

class_name ProjectileStats

var speed : float = 0 setget set_speed , get_speed
var damage : float = 0 setget set_damage, get_damage

func _init(speed_value = 0.0, damage_value = 0.0):
	speed = speed_value
	damage = damage_value


func set_speed(value) -> void:
	speed = value
	
func get_speed() -> float:
	return speed
	
func set_damage(value) -> void:
	damage = value

func get_damage() -> float:
	return damage
