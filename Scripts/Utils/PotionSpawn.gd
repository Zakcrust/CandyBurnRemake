extends Position2D


export (PackedScene) var item_to_spawn

func _spawn():
	if not get_child_count() > 0:
		add_child(item_to_spawn.instance())
