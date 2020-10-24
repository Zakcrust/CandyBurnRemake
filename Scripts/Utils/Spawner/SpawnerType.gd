extends Resource

class_name SpawnerType

var SPAWN_NAME : String = "" setget , get_spawn_name

func _init(sp_name = ""):
	SPAWN_NAME = sp_name

func get_spawn_name() -> String:
	return SPAWN_NAME
