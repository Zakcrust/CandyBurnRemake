extends KinematicBody2D

class_name PermenKacamata

signal send_bullet(obj)

var character_stats : Stats = Stats.new(500)
var SPEED = 75

var summon_counts : int = 0

func decrease_summon_count() -> void:
	summon_counts -= 1
