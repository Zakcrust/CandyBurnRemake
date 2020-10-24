extends Resource

class_name Wave

var spawner_id : int = 0 setget , get_id
var spawn_count : int = 0 setget , get_spawn_count
var enemy_to_spawn : String = "" setget , get_enemy


func _init(id = 0, count = 0, enemy = ""):
	spawner_id = id
	spawn_count = count
	enemy_to_spawn = enemy

func get_id() -> int:
	return spawner_id

func get_spawn_count() -> int:
	return spawn_count

func get_enemy() -> String:
	return enemy_to_spawn

