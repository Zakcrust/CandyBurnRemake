extends Node

class_name WeaponStats


var weapon_id : String setget, get_weapon_id
var weapon_name : String setget , get_weapon_name
var sprite_path : String setget , get_sprite_path
var damage : int setget , get_damage
var bullet_speed : int setget , get_bullet_speed
var energy_cost : float setget , get_energy_cost

func _init(id : String ,name_init : String, path : String, damage_init : int, bullet_speed_init : int = 0, p_energy_cost = 0.0):
	weapon_id = id
	weapon_name = name_init
	sprite_path = path
	damage = damage_init
	bullet_speed = bullet_speed_init
	energy_cost = p_energy_cost


func get_weapon_id() -> String:
	return weapon_id

func get_weapon_name() -> String:
	return weapon_name

func get_sprite_path() -> String:
	return sprite_path

func get_damage() -> int:
	return damage

func get_bullet_speed() -> int:
	return bullet_speed

func get_energy_cost() -> float:
	return energy_cost
