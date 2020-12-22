extends Node

export (NodePath) var trail_parent

export (int) var length : int = 10
var point : Vector2

func _ready():
	$Trail.default_color = Color.lightblue

func _process(delta):
	$Trail.global_position = Vector2()
	$Trail.global_rotation = 0
	point = get_node(trail_parent).global_position
	$Trail.add_point(point)
	while $Trail.get_point_count() > length:
		$Trail.remove_point(0)
