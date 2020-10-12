extends Stats

class_name MobStats

var attack : int = 0 setget set_attack, get_attack
var defend : int = 0 setget set_defend, get_defend

func _init(health_value = 1,attack_value = 1, defend_value = 0):
	._init(health_value)
	attack = attack_value
	defend = defend_value
	
func set_attack(value : int) -> void:
	attack = value

func get_attack() -> int:
	return attack

func set_defend(value : int) -> void:
	defend = value

func get_defend() -> int:
	return defend
