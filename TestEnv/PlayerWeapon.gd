extends Node

class_name PlayerWeapon

var damage : float = 0.0 setget set_damage, get_damage
var type : String = "" setget , get_type

var GUN : String = "GUN" 			setget , get_gun
var BOMB : String = "BOMB" 			setget , get_bomb
var FLAME : String = "FLAME"	 	setget, get_flame

func _init(damage_value = 0.0, weapon_type = ""):
	damage = damage_value
	type = weapon_type

func set_damage(value) -> void:
	damage = value

func get_damage() -> float:
	return damage

func get_type() -> String:
	return type

func get_gun() -> String:
	return GUN

func get_flame() -> String:
	return FLAME

func get_bomb() -> String:
	return BOMB
