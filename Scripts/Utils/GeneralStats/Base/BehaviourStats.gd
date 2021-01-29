extends Node

class_name BehaviourStats

var attack_radius : float = 0.0 setget , get_attack_radius
var detect_radius : float = 0.0 setget , get_detect_radius

func _init(attack_radius_init : float = 0.0, detect_radius_init : float = 0.0):
	attack_radius = attack_radius_init
	detect_radius = detect_radius_init

func get_attack_radius() -> float:
	return attack_radius

func get_detect_radius() -> float:
	return detect_radius

