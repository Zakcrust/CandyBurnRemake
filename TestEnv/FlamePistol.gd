extends PlayerWeapon

var asset_path : String = "res://TestEnv/Assets/Player/FlamePistol/flame_pistol.tres" setget set_hand_sprite_path , get_hand_sprite
var weapon_name : String = "Flamer Pistol" setget set_weapon_name , get_weapon_name
var bullet_scene_path : String = "res://TestEnv/Bullet.tscn" setget set_bullet_scene_path , get_bullet_scene_path
var reload_time : float = 0.0 
func _init(reload_time_value = 0.0 ,damage_value = 0, type = PlayerWeapon.new().GUN):
	._init(damage_value, type)
	reload_time = reload_time_value

func set_reload_time(value) -> void:
	reload_time = value

func get_reload_time() -> float:
	return reload_time

func set_hand_sprite_path(value) -> void:
	asset_path = value

func set_weapon_name(value) -> void:
	weapon_name = value

func set_bullet_scene_path(value) -> void:
	bullet_scene_path = value
	
func get_hand_sprite() -> String:
	return asset_path

func get_weapon_name() -> String:
	return weapon_name

func get_bullet_scene_path() -> String:
	return bullet_scene_path
