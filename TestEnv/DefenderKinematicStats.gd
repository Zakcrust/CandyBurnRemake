extends EnemyKinematicStats

var attack_radius : float = 0.0 setget set_attack_radius, get_attack_radius

func _init(detect_radius_value = 0, view_radius_value = 0, attack_radius_value = 0):
	._init(detect_radius_value, view_radius_value)
	attack_radius = attack_radius_value

func set_attack_radius(value : float) -> void:
	attack_radius = value
	
func get_attack_radius() -> float:
	return attack_radius
