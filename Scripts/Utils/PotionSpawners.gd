extends Node2D

func _spawn_potions():
	for child in get_children():
		if child is Position2D:
			child._spawn()
