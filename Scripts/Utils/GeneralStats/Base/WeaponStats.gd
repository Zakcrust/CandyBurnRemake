extends Node

class_name WeaponStats

var weapon_name : String setget , get_weapon_name
var sprite_path : String setget , get_sprite_path
var damage : int setget , get_damage
var bullet_speed : int setget , get_bullet_speed

func _init(name_init : String, path : String, damage_init : int, bullet_speed_init : int = 0):
	weapon_name = name_init
	sprite_path = path
	damage = damage_init
	bullet_speed = bullet_speed_init


func get_weapon_name() -> String:
	return weapon_name

func get_sprite_path() -> String:
	return sprite_path

func get_damage() -> int:
	return damage

func get_bullet_speed() -> int:
	return bullet_speed
