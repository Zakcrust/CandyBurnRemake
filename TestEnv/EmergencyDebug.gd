extends Node2D

var alive_enemies : int = 0


func get_alive_enemies() -> int:
	alive_enemies = 0
	for enemy in get_children():
		if enemy.has_method("get_dead"):
			if not enemy.get_dead():
				alive_enemies += 1
	return alive_enemies

func _process(delta):
	if get_alive_enemies() == 0:
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().reload_current_scene()
