extends KinematicStats

class_name EnemyKinematicStats
	
var view_radius : float = 0.0 setget set_view_radius, get_view_radius
func _init(detect_radius_value = 0, view_radius_value = 0):
	._init(detect_radius_value)
	view_radius = view_radius_value
	
func set_view_radius(value : float) -> void:
	view_radius = value

func get_view_radius() -> float:
	return view_radius
