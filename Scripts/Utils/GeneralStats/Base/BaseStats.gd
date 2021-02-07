extends Node

class_name BaseStats

var health : float = 0
var energy : float = 0
var armour : int = 0
var speed : int = 0
var attack : int = 0
var behaviour_stats : BehaviourStats

func _init(health_init : int = 0, 
			energy_init : int = 0,
			armour_init : int = 0, 
			speed_init : int = 0, 
			attack_init : int = 0,
			behaviour_init = BehaviourStats.new() ):

	health = health_init
	energy = energy_init
	armour = armour_init
	speed = speed_init
	attack = attack_init
	behaviour_stats = behaviour_init
