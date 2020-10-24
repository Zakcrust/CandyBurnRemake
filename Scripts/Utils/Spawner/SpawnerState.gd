extends Resource

class_name SpawnerState

var DEFAULT : String = "DEFAULT" setget , get_default
var CLEARED : String = "CLEARED" setget, get_cleared

var current_state : String = "" setget set_state, get_state

func _init(default_state = "DEFAULT"):
	current_state = default_state


func get_default() -> String:
	return DEFAULT

func get_cleared() -> String:
	return CLEARED

func set_state(value) -> void:
	current_state = value

func get_state() -> String:
	return current_state
