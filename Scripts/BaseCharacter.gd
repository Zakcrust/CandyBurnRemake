extends KinematicBody2D

class_name Character

var character_type : String setget , get_character_type 
var character_stats : BaseStats setget , get_character_stats

func _init(type_init : String = "", stats_init = BaseStats.new()):
	character_type = type_init
	character_stats = stats_init

func get_character_type() -> String:
	return character_type

func get_character_stats() -> BaseStats:
	return character_stats
