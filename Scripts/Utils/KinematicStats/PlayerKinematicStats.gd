extends KinematicStats

class_name PlayerKinematicStats

var speed : float = 0.0 setget , get_speed

func _init(radius_value = 0, speed_value = 0.0):
	._init(radius_value)
	speed = speed_value


func get_speed() -> float:
	return speed
