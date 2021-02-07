extends Node

class_name PlayerWeapons

const FLAME_PISTOL = "FLAME_PISTOL"
const FLAMETHROWER = "FLAME_THROWER"

### WEAPON STATS PROPERTIES
# - Weapon id (String)
# - Weapon name (String)
# - Weapon asset path (String)
# - Weapon damage (int)
# - Bullet speed [if weapon has bullets] (float)
# - Energy cost [if weapon consumes energy] (float)

var weapons = [
	WeaponStats.new(FLAME_PISTOL ,"Flame Pistol", "res://Assets/MainCharacter/Flamepistol/Flamepistol.tres", 2, 3000, 0),
	WeaponStats.new(FLAMETHROWER ,"Flamethrower", "res://Assets/MainCharacter/FlameThrower/Flamethrower.tres", 25, 0, 10.0)
	]


func get_weapon(id : String) -> WeaponStats:
	for weapon in weapons:
		print(weapon.weapon_id)
		if weapon.weapon_id == id:
			return weapon
	return null
